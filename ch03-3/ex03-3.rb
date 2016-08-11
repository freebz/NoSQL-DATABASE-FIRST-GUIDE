require 'redis'

def login
  redis = Redis.new

  if params[:commit]
    user_id = redis.hget :user_info, "#{params[:user_name]}:user_id"
	stored_password = @redis.hget :user_info, "#{user_id}:password"

	if stored_password == Digest::SHA256.hexdigest(params[:password])
	  auth = create_auth
	  redis.hset :user_info, "#{user_id}:auth", auth
	  redis.hset :user_info, "#{auth}:user_id", user_id
	  store_cookie(auth)
	else
	  # 입력이 틀렸을 경우의 처리
	end

	flash[:msg] = "로그인 하였습니다"
	redirect_to :action => "index"
  end
end

