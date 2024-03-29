(use-package ivy
  :defer 1
  :demand
  :hook (after-init . ivy-mode)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
	ivy-initial-inputs-alist nil
	ivy-count-format "%d/%d "
	enable-recursive-minibuffers t
	ivy-re-builders-alist '((t . ivy--regex-ignore-order))))

(use-package counsel
  :after (ivy)
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c f" . counsel-recentf)
	 ("C-c g" . counsel-git)))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
	 ("C-r" . swiper-isearch-backward))
  :config (setq swiper-action-recenter t
		swiper-include-line-number-in-search t))

(use-package restart-emacs)

(use-package lua-mode
  :defer 1)

;; gruvbox-theme
;;(use-package gruvbox-theme
;;  :init (load-theme 'gruvbox-dark-soft t))

;;(use-package smart-mode-line
;;  :init
;;  (setq sml/no-confirm-load-theme t)
;;  (setq sml/theme 'respectful)
;;  (sml/setup))

(provide 'init-package)
