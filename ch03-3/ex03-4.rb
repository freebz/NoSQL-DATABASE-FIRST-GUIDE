require 'redis'

def login?
  redis = Redis.new

  if cookies[:auth]
    @user_id = redis.hget :user_info, "#{cookies[:auth]}:user_id"
  end

  !@user_id.blank?
end

