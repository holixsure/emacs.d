(add-to-list 'load-path
	     (expand-file-name (concat user-emacs-directory "lisp")))



(add-to-list 'image-types 'svg)

(eval-and-compile
  (require 'package)
  (setq package-archives '(("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
			   ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
			   ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")

			   ;; ("elpa" . "https://elpa.gnu.org/packages/")
			   ;; ("org" . "https://orgmode.org/elpa/")
			   ;; ("gnu" . "https://elpa.gnu.org/packages/")
			   ;; ("melpa" . "https://melpa.org/packages/")
			  ))
  (package-initialize)
  ;;
  (package-refresh-contents)
  (unless (package-installed-p 'use-package)
    (package-install 'use-package))
  (require 'use-package)
  ;;
  (setf use-package-always-ensure t))

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




(require 'init-ui)



;; 取消自动备份
(setq make-backup-files nil)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(restart-emacs ivy use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
