(use-package elfeed
  :bind (("C-x w" . elfeed)))

(setq elfeed-feeds
      '("http://nullprogram.com/feed/"
	"https://protesilaos.com/codelog.xml"
;;	"https://rsshub.app/nga/forum/-7955747"
;;	"https://www.v2ex.com/feed/create.xml"
	"https://plink.anyfeeder.com/weixin/MSRAsia"
;;	"http://feeds.feedburner.com/BBC/China"
;;	"http://feeds.feedburner.com/voacn"
;;	"http://feeds.feedburner.com/gaopi"
;;	"http://feeds.feedburner.com/china-week"
	"https://plink.anyfeeder.com/nytimes/cn"))

(provide 'init-elfeed)
