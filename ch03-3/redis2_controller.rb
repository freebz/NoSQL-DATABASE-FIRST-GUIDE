class Redis2Controller < ApplicationController
  require 'redis'
  require 'nokogiri'
  require 'open-uri'

  KCODE = 'u'

  before_filter :init
  ATND_API_URL = 'http://api.atnd.org/events/'

  def index
    if params[:k] || params[:t]

	  uri = URI("#{ATND_API_URL}?#{construct_search_query}")

	  doc = Nokogiri::XML(uri.read)

	  @data = []
	  if doc.search('events')
	    doc.search('events').each do |event|
	      @data << {
		    :title => event.xpath('title').text,
		    :url => event.xpath('event_url').text,
		    :description => event.xpath('description').text.split(//)[0..199].join(''),
		    :started_at => event.xpath('started_at').text
		  }
        end
      end

	  store_history
    end

    get_recent_history
  end

  private

  def init
    @redis = Redis.new
  end

  def store_history
    @redis.lpush :history, "#{params[:k]}|#{params[:t]}"
  end

  def get_recent_history
    @histories = @redis.lrange :history, 0, 9
  end

  def construct_search_query
    _options = {
	  :keyword => params[:k],
	  :twitter_id => params[:t],
	  :count => 20
	}

    _options.map{|k,v| "#{k}=#{v}"}.join("&")
  end
end

