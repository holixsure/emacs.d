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
  (setf use-package-always-ensure t)

  ;;
  (setq use-package-always-ensure t)
  (setq use-package-always-defer t)
  (setq use-package-always-demand nil)
  (setq use-package-expand-minimally t)
  (setq use-package-verbose t))

(provide 'init-elpa)
