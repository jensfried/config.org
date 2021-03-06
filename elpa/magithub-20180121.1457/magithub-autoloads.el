;;; magithub-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (directory-file-name (or (file-name-directory #$) (car load-path))))

;;;### (autoloads nil "magithub" "magithub.el" (23145 56599 99151
;;;;;;  853000))
;;; Generated autoloads from magithub.el
 (autoload 'magithub-dispatch-popup "magithub" nil t)

;;;***

;;;### (autoloads nil "magithub-comment" "magithub-comment.el" (23145
;;;;;;  56599 103151 105000))
;;; Generated autoloads from magithub-comment.el

(autoload 'magithub-comment-new "magithub-comment" "\
Comment on ISSUE in a new buffer.
If prefix argument DISCARD-DRAFT is specified, the draft will not
be considered.

If INITIAL-CONTENT is specified, it will be inserted as the
initial contents of the reply if there is no draft.

\(fn ISSUE &optional DISCARD-DRAFT INITIAL-CONTENT)" t nil)

;;;***

;;;### (autoloads nil "magithub-core" "magithub-core.el" (23145 56599
;;;;;;  111149 610000))
;;; Generated autoloads from magithub-core.el

(autoload 'magithub--section-value-at-point "magithub-core" "\
Determine the thing of TYPE at point.
This is intended for use as a resolving function for
`thing-at-point'.

The following symbols are defined, but other values may work with
this function: `github-user', `github-issue', `github-label',
`github-comment', `github-repository', `github-pull-request',
`github-notification',

\(fn TYPE)" nil nil)

(put 'github-user 'thing-at-point (lambda nil (magithub--section-value-at-point 'user)))

(put 'github-issue 'thing-at-point (lambda nil (or magithub-issue (magithub--section-value-at-point 'issue))))

(put 'github-label 'thing-at-point (lambda nil (magithub--section-value-at-point 'label)))

(put 'github-comment 'thing-at-point (lambda nil (or magithub-comment (magithub--section-value-at-point 'comment))))

(put 'github-notification 'thing-at-point (lambda nil (magithub--section-value-at-point 'notification)))

(put 'github-repository 'thing-at-point (lambda nil (or (magithub--section-value-at-point 'repository) magithub-repo (magithub-repo))))

(put 'github-pull-request 'thing-at-point (lambda nil (or (magithub--section-value-at-point 'pull-request) (when-let* ((issue (thing-at-point 'github-issue))) (and (magithub-issue--issue-is-pull-p issue) (magithub-cache :issues `(magithub-request (ghubp-get-repos-owner-repo-pulls-number ',(magithub-issue-repo issue) ',issue))))))))

;;;***

;;;### (autoloads nil "magithub-dash" "magithub-dash.el" (23145 56599
;;;;;;  115148 862000))
;;; Generated autoloads from magithub-dash.el

(autoload 'magithub-dashboard "magithub-dash" "\
View your GitHub dashboard.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "magithub-edit-mode" "magithub-edit-mode.el"
;;;;;;  (23145 56599 91153 348000))
;;; Generated autoloads from magithub-edit-mode.el

(autoload 'magithub-edit-mode "magithub-edit-mode" "\
Major mode for editing GitHub issues and pull requests.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "magithub-issue-tricks" "magithub-issue-tricks.el"
;;;;;;  (23145 56599 115148 862000))
;;; Generated autoloads from magithub-issue-tricks.el

(autoload 'magithub-pull-request-merge "magithub-issue-tricks" "\
Merge PULL-REQUEST with ARGS.
See `magithub-pull-request--completing-read'.  If point is on a
pull-request object, that object is selected by default.

\(fn PULL-REQUEST &optional ARGS)" t nil)

;;;***

;;;### (autoloads nil "magithub-issue-view" "magithub-issue-view.el"
;;;;;;  (23145 56599 107150 358000))
;;; Generated autoloads from magithub-issue-view.el

(autoload 'magithub-issue-view "magithub-issue-view" "\
View ISSUE in a new buffer.
Return the new buffer.

\(fn ISSUE)" t nil)

;;;***

;;;### (autoloads nil nil ("magithub-ci.el" "magithub-faces.el" "magithub-issue-post.el"
;;;;;;  "magithub-issue.el" "magithub-label.el" "magithub-notification.el"
;;;;;;  "magithub-orgs.el" "magithub-pkg.el" "magithub-proxy.el"
;;;;;;  "magithub-repo.el" "magithub-user.el") (23145 56599 119148
;;;;;;  115000))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; magithub-autoloads.el ends here
