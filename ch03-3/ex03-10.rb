require 'redis'

def store_history
  redis = Redis.new

  rdis.lpush :history, "#{params[:k]}|#{params[:t]}"
end

