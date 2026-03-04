;;; init.el --- Emacs init profile  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


;;; Performance optimization
(setq gc-cons-threshold (* 100 1024 1024))


;; Put all auto-generated configurations in a separate file
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)


(add-to-list 'load-path
	     (expand-file-name (concat user-emacs-directory "lisp")))


(require 'init-startup)
(require 'init-ui)


;; Set up the package manager
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)



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
the minibuffer is open.  Whereas we want it to close the
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



;; Use the preferred fonts
(let ((mono-spaced-font "Monospace")
      (proportionately-spaced-font "Sans"))
  (cond
   ((eq system-type 'windows-nt)
    (set-face-attribute 'default nil :family mono-spaced-font :height 100))
   ((eq system-type 'darwin)
    (set-face-attribute 'default nil :family mono-spaced-font :height 140))
   ((eq system-type 'gnu/linux)
    (set-face-attribute 'default nil :family mono-spaced-font :height 140)))
  (set-face-attribute 'fixed-pitch nil :family mono-spaced-font :height 1.0)
  (set-face-attribute 'variable-pitch nil :family proportionately-spaced-font :height 1.0))



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
(use-package dired
  :ensure nil
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package trashed
  :ensure t
  :commands (trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p)
  (setq trashed-use-header-line t)
  (setq trashed-sort-key '("Date deleted" . t))
  (setq trashed-date-format "%Y-%m-%d %H:%M:%S"))



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
  (setq magit-log-section-commit-count 100))


;;(use-package swiper
;;  :ensure t
;;  :config
;;  (setq ivy-wrap t)
;;  :bind (("C-s" . swiper)
;;	 ("C-r" . swiper)))

;; consult
(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)
	 ("C-x b" . consult-buffer)
	 ("M-y" . consult-yank-pop)
	 ("M-g g" . consult-goto-line)))


;; eat
;;(use-package eat
;;  :ensure t)


;; vterm
;;(use-package vterm
;;  :ensure t)


;; leetcode
;;(use-package leetcode
;;  :ensure t)


;; projectile - project navigation
;;(use-package projectile
;;  :ensure t
;;  :config
;;  (projectile-mode +1)
;;  (setq projectile-completion-system 'default))


;; lsp-ui - LSP UI enhancements
;;(use-package lsp-ui
;;  :ensure t
;;  :after lsp-mode
;;  :config
;;  (setq lsp-ui-doc-enable t)
;;  (setq lsp-ui-doc-position 'bottom)
;;  (setq lsp-ui-doc-delay 0.5))


;; ace-window
(use-package ace-window
  :ensure t
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))


;; Elpy, the Emacs Python IDE
;;(use-package elpy
;;  :ensure t
;;  :init
;;  (elpy-enable))



;;;; ==============================
;;;; Python Development Setup
;;;; ==============================

;; -------- 性能优化 --------

(setq read-process-output-max (* 1024 1024)) ;; 1MB
(setq lsp-idle-delay 0.2)
(setq gc-cons-threshold (* 100 1024 1024))

;; -------- Python Mode --------

(use-package python
  :ensure nil
  :hook (python-mode . lsp-deferred)
  :config
  (setq python-shell-interpreter "python3"
        python-indent-offset 4))

;; Emacs 29 treesit
(when (fboundp 'treesit-available-p)
  (setq major-mode-remap-alist
        '((python-mode . python-ts-mode))))

;; -------- LSP --------

(use-package lsp-mode
  :commands lsp lsp-deferred
  :hook (python-mode . lsp-deferred)
  :config
  (setq lsp-keymap-prefix "C-c l"
        lsp-prefer-flymake nil
        lsp-enable-symbol-highlighting t
        lsp-headerline-breadcrumb-enable t))

(use-package lsp-ui
  :after lsp-mode
  :config
  (setq lsp-ui-doc-position 'at-point
        lsp-ui-doc-delay 0.3))

(use-package lsp-pyright
  :after lsp-mode
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred))))

;; -------- 补全（已存在 corfu，不重复定义）--------

;; -------- Lint (Ruff 推荐) --------

(use-package flycheck
  :init (global-flycheck-mode))

(after! flycheck
  (setq flycheck-python-ruff-executable "ruff"))

;; -------- 自动格式化 --------

(use-package blacken
  :hook (python-mode . blacken-mode)
  :config
  (setq blacken-line-length 88))

;; -------- 虚拟环境 --------

(use-package pyvenv
  :config
  (pyvenv-mode 1))

(use-package direnv
  :config
  (direnv-mode))

;; -------- Debug --------

(use-package dap-mode
  :after lsp-mode
  :config
  (require 'dap-python)
  (setq dap-python-debugger 'debugpy)
  (dap-auto-configure-mode))

;; F5 启动调试
(global-set-key (kbd "<f5>") #'dap-debug)

;;;; ==============================
;;;; End Python Setup
;;;; ==============================


;;; ECA
;;(use-package eca
;;  :vc (:url "https://github.com/editor-code-assistant/eca-emacs" :rev :newest))


;;; Agent-Shell
(use-package agent-shell)


;; test
(add-to-list 'load-path "/Users/HolixSure/Documents/Drive/Tools/Emacs/holixsure-chat")
(require 'holixsure-chat)



