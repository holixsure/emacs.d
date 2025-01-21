(use-package elfeed
  :ensure t
  :bind (("C-x w" . elfeed))
  :config
  (setq elfeed-feeds
	'("http://nullprogram.com/feed/"
	  "https://plink.anyfeeder.com/nytimes/cn"
	  "https://plink.anyfeeder.com/weixin/MSRAsia"
	  "https://protesilaos.com/codelog.xml"
	  "https://tech.meituan.com/feed"
	  ))
  (setq-default elfeed-search-filter "@6-months-ago "))



(provide 'init-elfeed)
