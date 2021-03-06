(require 'magithub-core)
(require 'magithub-issue)
(require 'magithub-label)
(require 'magithub-edit-mode)

(declare-function magithub-issue-view "magithub-issue-view.el" (issue))

(defvar-local magithub-issue--extra-data nil)

(defun magithub-issue-post-submit ()
  (interactive)
  (let ((issue (magithub-issue-post--parse-buffer))
        (repo (magithub-repo)))
    (when (s-blank-p (alist-get 'title issue))
      (user-error "Title is required"))
    (when (magithub-repo-push-p repo)
      (when-let* ((issue-labels (magithub-label-read-labels "Labels: ")))
        (push (cons 'labels issue-labels) issue)))
    (when (yes-or-no-p "Are you sure you want to submit this issue? ")
      (let ((issue (magithub-request
                    (ghubp-post-repos-owner-repo-issues repo issue))))
        (magithub-issue-view issue)))))

(defun magithub-issue-post--parse-buffer ()
  (let ((lines (split-string (buffer-string) "\n")))
    `((title . ,(s-trim (car lines)))
      (body . ,(s-trim (mapconcat #'identity (cdr lines) "\n"))))))

(defun magithub-issue-new (repo)
  (interactive (list (magithub-repo)))
  (with-current-buffer
      (magithub-edit-new (format "*magithub-issue: %s*" (magithub-repo-name repo))
        :header (format "Creating an issue for %s" (alist-get 'full_name repo))
        :submit #'magithub-issue-post-submit
        :file (expand-file-name "new-issue-draft"
                                (magithub-repo-data-dir repo))
        :template (magithub-issue--template-text "ISSUE_TEMPLATE"))
    (font-lock-add-keywords nil `((,(rx bos (group (*? any)) eol) 1
                                   'magithub-issue-title-edit t)))
    (magithub-bug-reference-mode-on)
    (magit-display-buffer (current-buffer))))

(defun magithub-issue--template-text (template)
  (with-temp-buffer
    (when-let* ((template (magithub-issue--template-find template)))
      (insert-file-contents template)
      (buffer-string))))

(defun magithub-issue--template-find (filename)
  "Find an appropriate template called FILENAME and returns its absolute path.

See also URL
`https://github.com/blog/2111-issue-and-pull-request-templates'"
  (let ((default-directory (magit-toplevel))
        combinations)
    (dolist (tryname (list filename (concat filename ".md")))
      (dolist (trydir (list default-directory (expand-file-name ".github/")))
        (push (expand-file-name tryname trydir) combinations)))
    (-find #'file-readable-p combinations)))

(defun magithub-remote-branches (remote)
  "Return a list of branches on REMOTE."
  (let ((regexp (concat (regexp-quote remote) (rx "/" (group (* any))))))
    (--map (and (string-match regexp it)
                (match-string 1 it))
           (magit-list-remote-branch-names remote))))

(defun magithub-remote-branches-choose (prompt remote &optional default)
  "Using PROMPT, choose a branch on REMOTE."
  (magit-completing-read
   (format "[%s] %s"
           (magithub-repo-name (magithub-repo-from-remote remote))
           prompt)
   (magithub-remote-branches remote)
   nil t nil nil default))

(defun magithub-pull-request-new-arguments ()
  (unless (magit-get-push-remote)
    (user-error "Nothing on remote yet; aborting"))
  (let* ((this-repo   (magithub-read-repo "Fork's remote (this is you!) "))
         (this-repo-owner (let-alist this-repo .owner.login))
         (parent-repo (or (alist-get 'parent this-repo) this-repo))
         (this-remote (car (magithub-repo-remotes-for-repo this-repo)))
         (on-this-remote (string= (magit-get-push-remote) this-remote))
         (base-remote (car (magithub-repo-remotes-for-repo parent-repo)))
         (head-branch (let ((branch (magithub-remote-branches-choose
                                     "Head branch" this-remote
                                     (when on-this-remote
                                       (magit-get-current-branch)))))
                        (unless (magit-rev-verify (magit-get-push-branch branch))
                          (user-error "`%s' has not yet been pushed to your fork (%s)"
                                      branch (magithub-repo-name this-repo)))
                        branch))
         (base        (magithub-remote-branches-choose
                       "Base branch" base-remote
                       (when on-this-remote
                         (magit-get-upstream-branch head-branch))))
         (user+head   (format "%s:%s" this-repo-owner head-branch)))
    (when (magithub-request (ghubp-get-repos-owner-repo-pulls parent-repo nil :head user+head))
      (user-error "A pull request on %s already exists for head \"%s\""
                  (magithub-repo-name parent-repo)
                  user+head))
    (unless (y-or-n-p (format "You are about to create a pull request to merge branch `%s' into %s:%s; is this what you wanted to do?"
                              user+head (magithub-repo-name parent-repo) base))
      (user-error "Aborting"))
    (let-alist parent-repo
      (list parent-repo base
            (if (string= this-remote base-remote)
                head-branch
              user+head)))))

(defun magithub-pull-request-new (repo base head)
  "Create a new pull request."
  (interactive (magithub-pull-request-new-arguments))
  (with-current-buffer
      (magithub-edit-new (format "*magithub-pull-request: %s into %s:%s*"
                                 head
                                 (magithub-repo-name repo)
                                 base)
        :header (let-alist repo (format "PR %s/%s (%s->%s)" .owner.login .name head base))
        :submit #'magithub-pull-request-submit
        :file (expand-file-name "new-pull-request-draft"
                                (magithub-repo-data-dir repo))
        :template (magithub-issue--template-text "PULL_REQUEST_TEMPLATE"))
    (font-lock-add-keywords nil `((,(rx bos (group (*? any)) eol) 1
                                   'magithub-issue-title-edit t)))
    (magithub-bug-reference-mode-on)
    (setq magithub-issue--extra-data
          `((base . ,base) (head . ,head)))
    (magit-display-buffer (current-buffer))))

(defun magithub-pull-request-submit ()
  (interactive)
  (let ((pull-request `(,@(magithub-issue-post--parse-buffer)
                        (base . ,(alist-get 'base magithub-issue--extra-data))
                        (head . ,(alist-get 'head magithub-issue--extra-data)))))
    (when (s-blank-p (alist-get 'title pull-request))
      (user-error "Title is required"))
    (when (yes-or-no-p "Are you sure you want to submit this pull request? ")
      (when (y-or-n-p "Allow maintainers to modify this pull request? ")
        (push (cons 'maintainer_can_modify t) pull-request))
      (let ((pr (condition-case _
                    (magithub-request
                     (ghubp-post-repos-owner-repo-pulls (magithub-repo) pull-request))
                  (ghub-422
                   (user-error "This pull request already exists!")))))
        (magithub-issue-view pr)))))

(provide 'magithub-issue-post)
