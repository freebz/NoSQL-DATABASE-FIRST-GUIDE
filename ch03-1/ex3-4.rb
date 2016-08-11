require 'rss'
require 'nokogiri'

API_URL = 'http://gdata.youtube.com/feeds/api/videos'
RSS_URL = 'http://gyao.yahoo.co.jp/rss/ranking/c/daily/music/'

@data = []

rss = open(RSS_URL) {|f| RSS::Parser.parse(f.read)}
rss.items.each do |item|
  if item.title =~ /(.+)┎([^┘]+)/
	artist = $1
	title = $2
  end

  _options = {
	:vq => URI.encode("#{artist} #{title}"),
	:format => 5
  }

  options = _options.map{|k,v| "#{k}=#{v}"}.join('&')
  uri = URI("#{API_URL}?#{options}")

  doc = Nokogiri::XML(uri.read)

  if doc.search('entry').blank?  # 동영상이 Youtube에 없으면
    @data << {
	  :artist => artist,
	  :title => title
	}
  else  # 동영상을 Youtube에서 찾았을 경우
    doc.search('entry').each do |entry|
	  @data << {
		:artist => artist,
		:title => title,
		:url => entry.xpath('media:group/media:content').first['url'],
		:type => entry.xpath('media:group/media:content').first['type'],
		:count => entry.xpath('yt:statistics').first['viewCount'],
	  }
      break  # 동영상 정보를 발견하면 검색을 중단
    end
  end
end

