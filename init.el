(require 'package)

(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.milkbox.net/packages/")
	     t)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/")
	     t)

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package auto-complete
  :ensure t)

(use-package nlinum-relative
  :ensure t
  :init (global-nlinum-relative-mode))

(use-package autopair
  :ensure t
  :init (autopair-global-mode))

(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode))

(use-package evil
  :ensure t
  :init (evil-mode t))

(use-package powerline
  :ensure t
  :init (powerline-center-theme)
  :config (setq powerline-default-separator 'wave))

(use-package powerline-evil
  :ensure t)

(use-package neotree
  :ensure t)

(use-package multiple-cursors
  :ensure t)

(use-package beacon
  :ensure t
  :init (when window-system (beacon-mode)))

(ac-config-default)
(defalias 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "C-+") 'mc/mark-next-like-this)
(global-set-key (kbd "C--") 'mc/mark-previous-like-this)
(global-set-key [f8] 'neotree-toggle)
(global-set-key [f12] 'projectile-find-file)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-/") 'undo-tree-visualize)

(setq ring-bell-function 'ignore)
(setq scroll-conservatively 100)
(setq inhibit-startup-message t)
(when window-system (global-hl-line-mode t))
(when window-system (setq frame-title-format "emacs"))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (flatland)))
 '(custom-safe-themes
   (quote
    ("9b59e147dbbde5e638ea1cde5ec0a358d5f269d27bd2b893a0947c4a867e14c1" "b3775ba758e7d31f3bb849e7c9e48ff60929a792961a2d536edec8f68c671ca5" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "58c6711a3b568437bab07a30385d34aacf64156cc5137ea20e799984f4227265" "72a81c54c97b9e5efcc3ea214382615649ebb539cb4f2fe3a46cd12af72c7607" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e" "3cc2385c39257fed66238921602d8104d8fd6266ad88a006d0a4325336f5ee02" "3cd28471e80be3bd2657ca3f03fbb2884ab669662271794360866ab60b6cb6e6" "e0d42a58c84161a0744ceab595370cbe290949968ab62273aed6212df0ea94b4" "987b709680284a5858d5fe7e4e428463a20dfabe0a6f2a6146b3b8c7c529f08b" "c48551a5fb7b9fc019bf3f61ebf14cf7c9cdca79bcb2a4219195371c02268f11" "96998f6f11ef9f551b427b8853d947a7857ea5a578c75aa9c4e7c73fe04d10b4" "c90fd1c669f260120d32ddd20168343f5c717ca69e95d2f805e42e88430c340e" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(linum-format " %5i ")
 '(package-selected-packages
   (quote
    (magithub helm ac-emmet ac-html ac-html-angular ac-html-bootstrap ac-html-csswatcher ac-inf-ruby ac-js2 ac-php ac-php-core ac-python projectile projectile-git-autofetch projectile-rails sublime-themes flatland-theme beacon multiple-cursors neotree evil powerline-evil powerline undo-tree autopair nlinum-relative smex which-key whick-key use-package spacemacs-theme auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
