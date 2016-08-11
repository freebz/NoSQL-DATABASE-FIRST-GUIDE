require 'redis'

def logout
  redis = Redis.new

  redis.hdel :user_info, "#{@user_id}:auth"
  redis.hdel :user_info, "#{cookies[:auth]}:user_id"
  store_cookie(nil, true)	# Cookie 삭제

  flash[:msg] = "로그아웃하였습니다"
  redirect_to :action => "index"
end

