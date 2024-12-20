;;(setq org-agenda-files '("~/Documents/Drive/GTD"))
;;(setq org-default-notes-file "~/Documents/Drive/GTD/todo.org")

;;(global-set-key (kbd "\C-c a") 'org-agenda)
;;(global-set-key (kbd "\C-c r") 'org-capture)

(setq org-todo-keywords
      '((sequence "TODO(t)" "DOING(i!)" "|" "DONE(d!)" "ABORT(a@/!)")
	(sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")))
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "#FF4500" :weight bold))
	("DOING" . (:foreground "#33cc33" :weight bold))
	("DONE" . (:foreground "#27AE60" :weight bold))
	("ABORT" . (:foreground "#FF4500" :weight bold))))

(provide 'init-org)
