require 'redis'

def follow
  redis = Redis.new

  if cookies[:auth]
    @user_id = redis.hget :user_info, "#{cookies[:auth]}:user_id"
  end

  # params[:id]에는 팔로우한 사용자의 사용자명이 들어간다
  target_user_id = redis.hget :user_info, "#{params[:id]}:user_id"
  redis.sadd "#{@user_id}:following", target_user_id
  redis.sadd "{target_user_id}:followers", @user_id

  render :text => "<span style='color:red;font-weight:bold'>followed</span>"
end

