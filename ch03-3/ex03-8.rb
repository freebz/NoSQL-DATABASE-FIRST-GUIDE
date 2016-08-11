require 'redis'

def show
  redis = Redis.new

  # params[:id]에는 요청하고 있는 페이지의 사용자명이 들어간다
  # http://192.168.11.9:3000/redis/show/sasata299 라면 sasata299
  user_id = redis.hget :user_info, "#{params[:id]}:user_id"

  if user_id
    if user_id == @user_id
	  @page_title = "this is your page"
	else
	  @page_title = "the page of #{params[:id]}"
	end
	fetch_user_posts(user_id)
  end

  render :action => "index"
end

def fetch_user_posts(user_id)

  post_ids = redis.lrange "#{user_id}:posts", 0, 9

  @timeline = []
  post_ids.each do |post_id|
    @timelien << redis.get("post:#{post_id}")
  end
end

