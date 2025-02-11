(use-package elfeed
  :ensure t
  :bind (("C-x w" . elfeed))
  :config
  (setq elfeed-feeds
	'("http://nullprogram.com/feed/"
	  "https://plink.anyfeeder.com/nytimes/cn"
	  "https://plink.anyfeeder.com/weixin/MSRAsia"
	  "https://protesilaos.com/codelog.xml"
	  ))
  (setq-default elfeed-search-filter "@6-months-ago +unread "))



(provide 'init-elfeed)
