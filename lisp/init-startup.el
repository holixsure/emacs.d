(add-to-list 'image-types 'svg)

;; 取消自动保存
(setq auto-save-default nil)
;; 取消自动备份
(setq make-backup-files nil)
;; Don't show the splash screen
;;(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)

(provide 'init-startup)
