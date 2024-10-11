(add-to-list 'load-path
	     (expand-file-name (concat user-emacs-directory "lisp")))


(require 'init-startup)
(require 'init-elpa)
(require 'init-package)
(require 'init-ui)
(require 'init-org)
(require 'init-git)
(require 'init-python)

(require 'sort-tab)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lua-mode use-package smart-mode-line restart-emacs gruvbox-theme counsel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
