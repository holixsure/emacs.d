;;; init.el --- Emacs init profile -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:



;; Put all auto-generated configurations in a separate file
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)


(add-to-list 'load-path
	     (expand-file-name (concat user-emacs-directory "lisp")))

;; Do not show the *Warning* window
(add-to-list 'display-buffer-alist
	     '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
	       (display-buffer-no-window)
	       (allow-no-window . t)))


;; Set up package manager
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)



;; Disable auto save
(setq auto-save-default nil)

;; Disable backup
(setq make-backup-files nil)





;; Don't show the splash screen
(setq inhibit-startup-screen t)

;; scroll bar
(scroll-bar-mode -1)

;; tool bar
(tool-bar-mode -1)

;; menu bar
(menu-bar-mode -1)

;; high light line
(global-hl-line-mode 1)

;; line number
(global-display-line-numbers-mode 1)

;; maximize window
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;;(set-frame-parameter nil 'fullscreen 'maximized)

;; font size and font family
(let ((mono-spaced-font
       (cond
;;;	((eq system-type 'darwin) "Menlo")
	((eq system-type 'darwin) "SF Mono")
;;;	((eq system-type 'darwin) "Sarasa Mono SC")
	((eq system-type 'windows-nt) "JetBrains Mono")
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






;; Configure the minibuffer and rlated
;;     User Input
;;         │
;;         ▼
;;     Orderless    ← Completion Style
;;         │
;;         ▼
;;     Vertico      ← Completion UI
;;         │
;;         ▼
;;     Marginalia   ← Candidate Metadata
;;         │
;;         ▼
;;     Consult      ← Completion Commands
;; --------------------------------------------------
;; Orderless - Flexible matching style
;; --------------------------------------------------
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
  

;; --------------------------------------------------
;; Vertico - Minibuffer UI for completion
;; --------------------------------------------------
(use-package vertico
  ;; Enable Vertico after Emacs startup.
  ;; Vertico replaces the default horizontal completion UI
  ;; with a clean vertical candidate list in the minibuffer.
  ;; It only controls the UI layer - not matching logic.
  :hook (after-init . vertico-mode))

;; Maximum number of candidates displayed in the minibuffer.
;; Increasing this improves visibility when many matches exists.
(setq vertico-count 15)

;; Allow cyclic navigation in the candidate list.
;; When reaching the bottom, it continues from the top (and vice versa).
(setq vertico-cycle t)


;; --------------------------------------------------
;; Marginalia -Candidate annotations
;; --------------------------------------------------
(use-package marginalia
  ;; Adds contextual metadata to minibuffer candidates.
  ;; Examples:
  ;; - Commands show their type (Function, Command, etc.)
  ;; - Files show paths
  ;; - Buffers show major mode
  ;; This improves discoverability and clarity.
  :hook (after-init . marginalia-mode))


;; --------------------------------------------------
;; Consult - Enhanced navigation & search commands
;; --------------------------------------------------
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
;; Minibuffer config ends here.





;; Themes
(use-package modus-themes
  :config
  (load-theme 'modus-vivendi-tinted :no-confirm-loading))




;; magit
(use-package magit
  :config
  (setq magit-log-section-commit-count 100
	;; magit-status-margin '(t "%Y-%m-%d %H:%M:%S" magit-log-margin-width t 18)
	;; magit-section-initial-visibility-alist '((unstaged . hide) (commit . show))
	))


;; ace-window
(use-package ace-window
  :ensure t
  :bind
  ("M-o" . ace-window)
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Dirvish
(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode))


;; Treemacs
(use-package treemacs
  :ensure t
  :defer t
  :bind
  (("C-c t t" . treemacs)
   ("M-0" . treemacs-select-window)))




(use-package markdown-ts-mode
  :ensure nil
  :mode ("\\.md\\'" . markdown-ts-mode))

(use-package markdown-ts-appear
  :vc (markdown-ts-appear
       :url "https://github.com/Thysrael/markdown-ts-appear"
       :rev :newest)
  :hook (markdown-ts-mode . markdown-ts-appear-mode)
  :config
  (setq markdown-ts-appear-link-icon '("" . "↗")
      markdown-ts-appear-image-icon '("" . "▧")
      markdown-ts-appear-code-fence-style 'connected
      markdown-ts-appear-label-caps '("" . "")
      markdown-ts-appear-render-callouts t
      markdown-ts-appear-block-quote-marker "▎"
      markdown-ts-appear-table-style 'unicode))


(use-package mathjax
  :ensure t
  :defer t)

(setq markdown-ts-appear-enable-math-preview t)






;; rust
(let ((rustup-bin "/opt/homebrew/opt/rustup/bin"))
  (add-to-list 'exec-path rustup-bin)
  (setenv "PATH"
	  (concat rustup-bin
		  path-separator
		  (getenv "PATH"))))


;; Tree-sitter
(setq treesit-language-source-alist
      '((rust "https://github.com/tree-sitter/tree-sitter-rust")))
(add-to-list 'auto-mode-alist
	     '("\\.rs\\'" . rust-ts-mode))


;; Rust Alanlyzer + Eglot
(use-package eglot
  :ensure nil
  :hook
  (rust-ts-mode . eglot-ensure)

  :config
  (add-to-list
   'eglot-server-programs
   '(rust-ts-mode . ("rust-analyzer")))

  (setq-default
   eglot-workspace-configuration
   '(:rust-analyzer
     (:check
      (:command "clippy")))))


;; Completion
(use-package corfu
  :init
  (global-corfu-mode)

  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-cycle t))


;; Format on save
(defun my-rust-format-before-save ()
  (when (and (derived-mode-p 'rust-ts-mode)
	     (eglot-managed-p))
    (eglot-format-buffer)))

(add-hook 'before-save-hook #'my-format-before-save)


;; Diagnostics
(global-set-key (kbd "M-g n") #'flymake-goto-next-error)
(global-set-key (kbd "M-g p") #'flymake-goto-prev-error)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; hackernews
(use-package hackernews-modern
  :vc (:url "https://git.andros.dev/andros/hackernews-modern-el"
	    :rev :newest)
  :config
  (setq hackernews-modern-enable-emojis t))




