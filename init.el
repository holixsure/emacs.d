;; init.el --- Init file  -*- lexical-binding: t -*-


;; Put all auto-generated configurations in a separate file
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)


(add-to-list 'load-path
	     (expand-file-name (concat user-emacs-directory "lisp")))


;; Set up the package manager
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))


(require 'init-startup)


;; Set up use-package
(when (< emacs-major-version 29)
  (unless (package-installed-p 'use-package)
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'use-package)))



;; Do not show those confusing warnings when installing packages
(add-to-list 'display-buffer-alist
	     '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
	       (display-buffer-no-window)
	       (allow-no-window . t)))


;; Delete the selected text upon text insertion
(use-package delsel
  :ensure nil ; no need to install it as it is built-in
  :hook (after-init . delete-selection-mode))


;; Make C-g a bit more helpful
(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open. Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)



;; Decide what to do with the graphical bars
(require 'init-ui)
(require 'init-treemacs)


;; Use the preferred fonts
;;(let ((mono-spaced-font "Monospace")
;;      (proportionately-spaced-font "Sans"))
;;  (cond
;;   ((eq system-type 'windows-nt)
;;    (set-face-attribute 'default nil :family mono-spaced-font :height 100))
;;   ((eq system-type 'darwin)
;;    (set-face-attribute 'default nil :family mono-spaced-font :height 140))
;;   ((eq system-type 'gnu/linux)
;;    (set-face-attribute 'default nil :family mono-spaced-font :height 140)))
;;  (set-face-attribute 'fixed-pitch nil :family mono-spaced-font :height 1.0)
;;  (set-face-attribute 'variable-pitch nil :family proportionately-spaced-font :height 1.0))



;; Choose a theme and tweak the looks of Emacs
(use-package modus-themes
  :ensure t
  :config
  (load-theme 'modus-vivendi-tinted :no-confirm-loading))



;; Use icon fonts in various places
(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))



;; Configure the minibuffer and related
(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides nil))

(use-package savehist
  :ensure nil ; it is built-in
  :hook (after-init . savehist-mode))

(use-package corfu
  :ensure t
  :hook (after-init . global-corfu-mode)
  :bind (:map corfu-map ("<tab>" . corfu-complete))
  :config
  (setq tab-always-indent 'complete)
  (setq corfu-preview-current nil)
  (setq corfu-min-width 20)

  (setq corfu-popupinfo-delay '(1.25 . 0.5))
  (corfu-popupinfo-mode 1) ; shows documentation after `corfu-popupinfo-delay'

;; Sort by input history (no need to modify `corfu-sort-function').
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))



;; Tweak the dired Emacs file manager
;(use-package dired
;  :ensure nil
;  :commands (dired)
;  :hook
;  ((dired-mode . dired-hide-details-mode)
;   (dired-mode . hl-line-mode))
;  :config
;  (setq dired-recursive-copies 'always)
;  (setq dired-recursive-deletes 'always)
;  (setq delete-by-moving-to-trash t)
;  (setq dired-dwim-target t))

;(use-package dired-subtree
;  :ensure t
;  :after dired
;  :bind
;  ( :map dired-mode-map
;    ("<tab>" . dired-subtree-toggle)
;    ("TAB" . dired-subtree-toggle)
;    ("<backtab>" . dired-subtree-remove)
;    ("S-TAB" . dired-subtree-remove))
;  :config
;  (setq dired-subtree-use-backgrounds nil))

;(use-package trashed
;  :ensure t
;  :commands (trashed)
;  :config
;  (setq trashed-action-confirmer 'y-or-n-p)
;  (setq trashed-use-header-line t)
;  (setq trashed-sort-key '("Date deleted" . t))
;  (setq trashed-date-format "%Y-%m-%d %H:%M:%S"))



;; auto-highlight-symbol
;(use-package auto-highlight-symbol
;  :ensure t
;  :config
;;  (add-hook 'lisp-mode-hook #'auto-highlight-symbol-mode)
;;  (add-hood 'python-mode-hook #'auto-highlight-symbol-mode)
;  (global-auto-highlight-symbol-mode 1))



;; elfeed
;(require 'init-elfeed)



;; markdown-mode
(use-package markdown-mode
  :ensure t)


;(use-package slime
;  :ensure t
;  :config
;  (setq inferior-lisp-program "sbcl"))


;; gptel
(defun holixsure/gptel-api-key (host login)
  (let ((entry (car (auth-source-search
		     :host host
		     :login login
		     :require '(:secret)))))
    (when entry
      (let ((secret (plist-get entry :secret)))
	(if (functionp secret)
	    (funcall secret)
	  secret)))))

(use-package gptel
  :ensure t
  :config
  (setq gptel-default-mode 'org-mode
	gptel-backend (gptel-make-openai "OpenRouter"
			:host "openrouter.ai"
			:endpoint "/api/v1/chat/completions"
			:stream t
			:key (holixsure/gptel-api-key "openrouter.ai" "api-key")
			:models '(deepseek/deepseek-r1-0528-qwen3-8b:free))))



;; ultra-scroll
;;(use-package ultra-scroll
;;  :ensure t
;;  :init
;;  (setq scroll-conservatively 101
;;	scroll-margin 0)
;;  :config
;;  (ultra-scroll-mode 1))


(use-package magit
  :ensure t
  :config
  (setq magit-log-section-commit-count 30))


(use-package swiper
  :ensure t
  :config
  (setq ivy-wrap t)
  :bind (("C-s" . swiper)
	 ("C-r" . swiper)))


;; eat
(use-package eat
  :ensure t)


(global-set-key (kbd "M-o") #'other-window)

