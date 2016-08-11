require 'redis'

def index
  redis = Redis.new

  fetch_timeline
end

def fetch_timeline
  if login?
    post_ids = redis.lrange "timeline:#{@user_id}", 0, 9
  else
    post_ids = redis.lrange :timeline, 0, 9
  end

  @timeline = []
  post_ids.each do |post_id|
    @timeline << @redis.get("post:#{post_id}")
  end
end

