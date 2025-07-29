;; scroll bar
(scroll-bar-mode -1)

;; line number
(global-display-line-numbers-mode 1)

;; high light line
(global-hl-line-mode 1)

;; tool bar
(tool-bar-mode -1)

;; mneu bar
(menu-bar-mode -1)

;; Maximize window
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; fill-column-indicator
;;(global-display-fill-column-indicator-mode 1)



;; Smooth scroll up & down
(setq pixel-scroll-precision-interpolate-page t)
(add-hook 'after-init-hook #'pixel-scroll-precision-mode)

(defun pixel-scroll-down (&optional lines)
  (interactive)
  (if lines
      (pixel-scroll-precision-interpolate (* -1 lines (pixel-line-height)))
    (pixel-scroll-interpolate-down)))

(defun pixel-scroll-up (&optional lines)
  (interactive)
  (if lines
      (pixel-scroll-precision-interpolate (* lines (pixel-line-height))))
  (pixel-scroll-interpolate-up))

(defalias 'scroll-up-command 'pixel-scroll-interpolate-down)
(defalias 'scroll-down-command 'pixel-scroll-interpolate-up)


(provide 'init-ui)
