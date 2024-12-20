;; scroll bar
(scroll-bar-mode -1)

;; line number
(global-display-line-numbers-mode 1)

;; tool bar
(tool-bar-mode -1)

;; mneu bar
(menu-bar-mode -1)

;; Maximize window
(add-to-list 'default-frame-alist '(fullscreen . maximized))


(provide 'init-ui)
