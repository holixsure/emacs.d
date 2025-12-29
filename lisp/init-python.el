;; init-python.el


(use-package lsp-mode
  :ensure t
  :commands lsp
  :config
  (setq lsp-prefer-flymake nil)
  (setq lsp-idle-delay 0.5))


(use-package lsp-pyright
  :ensure t
  :after lsp-mode
  :custom
  (lsp-pyright-langserver-command "pyright-langserver")
  (lsp-pyright-python-executable-cmd "python3")
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp))))


(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :config
  (setq python-indent-offset 4)
  (setq python-shell-interpreter "python3")
  (setq python-shell-interpreter-args "-i"))


(use-package pyvenv
  :ensure t
  :config
  (setq pyvenv-mode-line-indicator
	'(pyvenv-virtual-env-name ("[venv:" pyvenv-virtual-env-name "] ")))
  (pyvenv-mode 1))


(use-package blacken
  :ensure t
  :hook (python-mode . blacken-mode)
  :config
  (setq blacken-line-length 88))


(use-package flycheck
  :ensure t
  :hook (python-mode . flycheck-mode))


(use-package pytest
  :ensure t
  :config
  (setq pytest-pytest-executable "python3 -m pytest"))


(use-package poetry
  :ensure t
  :hook (python-mode . poetry-tracking-mode))


(use-package pip-requirements
  :ensure t
  :mode ("requirements\\.txt\\'" . pip-requirements-mode))


(provide 'init-python)
