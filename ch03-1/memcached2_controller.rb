class Memcached2Controller < ApplicationController
  before_filter :init

  require 'memcache'
  require 'rss'
  require 'nokogiri'

  API_URL = 'http://gdata.youtube.com/feeds/api/videos'
  RSS_URL = 'http://gyyo.yahoo.co.jp/rss/ranking/c/daily/music/'

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
	date = @date.strftime("%Y%m%d")

	unless @data = @cache[date]
	  create_cache(date)
	end
  end

  private

  def init
    @cache = MemCache.new(['localhost:11211'])
  end

  def create_cache(date)
	@data = []

	rss = open(RSS_URL) {|f| RSS::Parser.parse(f.read)}
	rss.items.each do |item|
	  if item.title =~ /(.+)┌([^┘]+)/
	    artist = $1
		title = $2
	  end

	  _options = {
		:vq => URI.encode("#{artist} #{title}"),
		:format => 5
	  }

      options = _options.map{|k,v| "#{k}=#{v}"}.join('&')
	  uri = URI("#{API_URL}?{options}")

	  doc = Nokogiri::XML(uri.read)

	  if doc.search('entry').blank?  # 동영상을 찾지 못했을 경우
	    @data << {
		  :artist => artist,
		  :title => title
		}
      else  # 동영상을 발견한 경우
	    doc.search('entry').each do |entry|
		  @data << {
			:artist => artist,
			:title => title,
			:url => entry.xpath('media:group/media:content').first['url'],
			:type => entry.xpath('media:group/media:content').first['type'],
			:count => entry.xpath('yt:statistics').first['viewCount'],
		  }
          break
		end
	  end
	end

	@cache.set(date, @data, 86400)
  end
end

