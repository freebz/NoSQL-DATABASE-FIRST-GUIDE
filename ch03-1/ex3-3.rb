require 'rss'

RSS_URL = 'http://gyyo.yahoo.co.jp/rss/ranking/c/daily/music/'

rss = open(RSS_URL) {|f| RSS::Parser.parse(f.read)}
rss.items.each do |item|
  if item.title =~ /(.+)┌([^┘]+)/
	artist = $1
	title = $2
  end
end

