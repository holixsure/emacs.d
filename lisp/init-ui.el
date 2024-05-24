;; 隐藏滚动条
(scroll-bar-mode -1)

;; 启用行号
;; (global-linum-mode t)
(global-display-line-numbers-mode 1)

;; 隐藏工具栏
(tool-bar-mode -1)

;; 隐藏菜单栏
;; (menu-bar-mode -1)

;; 最大化窗口
(add-to-list 'default-frame-alist '(fullscreen . maximized))


(provide 'init-ui)
