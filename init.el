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
(let ((mono-spaced-font
       (cond
	((eq system-type 'darwin) "Menlo")
;;	((eq system-type 'darwin) "JetBrains Mono")
	((eq system-type 'windows-nt) "Consolas")
	(t "DejaVu Sans Mono")))
      (proportionately-spaced-font "Sans"))
  (cond
   ((eq system-type 'windows-nt)
    (set-face-attribute 'default nil
			:family mono-spaced-font
			:height 100))
   ((eq system-type 'darwin)
    (set-face-attribute 'default nil
			:family mono-spaced-font
			:height 140))
   ((eq system-type 'gnu/linux)
    (set-face-attribute 'default nil
			:family mono-spaced-font
			:height 140)))
  (set-face-attribute 'fixed-pitch nil
		      :family mono-spaced-font
		      :height 1.0)
  (set-face-attribute 'variable-pitch nil
		      :family proportionately-spaced-font
		      :height 1.0))



;; Choose a theme and tweak the looks of Emacs
(use-package modus-themes
  :config
  (load-theme 'modus-vivendi-tinted :no-confirm-loading))



;;; magit
(use-package magit
  :config
  (setq magit-log-section-commit-count 100))



;; Configure the minibuffer and related
;; ------------------------------------------
;; Vertico — Minibuffer UI for completion
;; ------------------------------------------
(use-package vertico
  ;; Enable Vertico after Emacs startup.
  ;; Vertico replaces the default horizontal completion UI
  ;; with a clean vertical candidate list in the minibuffer.
  ;; It only controls the UI layer — not matching logic.
  :hook (after-init . vertico-mode))

;; Maximum number of candidates displayed in the minibuffer.
;; Increasing this improves visibility when many matches exist.
(setq vertico-count 15)

;; Allow cyclic navigation in the candidate list.
;; When reaching the bottom, it continues from the top (and vice versa).
(setq vertico-cycle t)


;; ------------------------------------------
;; Marginalia — Candidate annotations
;; ------------------------------------------
(use-package marginalia
  ;; Adds contextual metadata to minibuffer candidates.
  ;; Examples:
  ;; - Commands show their type (Function, Command, etc.)
  ;; - Files show paths
  ;; - Buffers show major mode
  ;; This improves discoverability and clarity.
  :hook (after-init . marginalia-mode))

;; ------------------------------------------
;; Orderless — Flexible matching style
;; ------------------------------------------
(use-package orderless
  :config
  ;; Use orderless as the primary completion style.
  ;; This enables multi-keyword, unordered matching.
  ;; Example:
  ;;   typing "con buf" can match "consult-buffer"
  ;; 'basic' is kept as a fallback.
  (setq completion-styles '(orderless basic))
  ;; Disable category-specific defaults to ensure
  ;; all categories (files, buffers, commands, etc.)
  ;; use the same completion behavior.
  (setq completion-category-defaults nil)
  ;; No category-specific overrides.
  ;; You could customize file completion differently here if desired.
  (setq completion-category-overrides nil))


;; ------------------------------------------
;; Consult — Enhanced navigation & search commands
;; ------------------------------------------
(use-package consult
  :bind (
	 ;; Search within the current buffer.
         ;; Acts as a modern replacement for isearch.
         ;; Integrates with orderless + vertico.
	 ("C-s" . consult-line)
	 ;; Enhanced buffer switching.
         ;; Displays recent buffers and additional metadata.
	 ("C-x b" . consult-buffer)
	 ;; Visual kill-ring browser.
         ;; Replaces the default yank-pop with a previewable list.
	 ("M-y" . consult-yank-pop)
	 ;; Improved goto-line with live preview.
	 ("M-g g" . consult-goto-line)))



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
  "This is a test.
`HOST, `LOGIN."
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



;;(use-package swiper
;;  :ensure t
;;  :config
;;  (setq ivy-wrap t)
;;  :bind (("C-s" . swiper)
;;	 ("C-r" . swiper)))



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




;;; ECA
;;(use-package eca
;;  :vc (:url "https://github.com/editor-code-assistant/eca-emacs" :rev :newest))


;;; Agent-Shell
;;(use-package agent-shell)


;; test
(add-to-list 'load-path "/Users/HolixSure/Documents/Drive/Tools/Emacs/holixsure-chat")
(require 'holixsure-chat)



