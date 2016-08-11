require 'redis'

def get_recent_history
  redis = Redis.new

  @histories = redis.lrange :history, 0, 9
end

