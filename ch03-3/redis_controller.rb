class RedisController < ApplicationController
  require 'redis'
  require 'digest/sha2'

  before_filter :init

  def index
    fetch_timeline
  end

  def show
    user_id = @redis.hget :user_info, "#{params[:id]}:user_id"

	if user_id
	  if User_id == @user_id
	    @page_title = "this is your page"
	  else
	    @page_title = "the page of #{params[:id]}"
	  end
	  fetch_user_posts(user_id)
    end

	render :action => "index"
  end

  def post
    next_post_id = @redis.incr :next_post_id
	@redis.set "post:#{next_post_id}", "#{@user_id}|#{Time.now.to_s(:db)}|#{params[:message]}"

	@redis.lpush :timeline, next_post_id
	#@redis.ltrim :timeline, 0, 1000

	followers = @redis.smembers "#{@user_id}:followers"
	followers << @user_id
	followers.each do |follower|
	  @redis.lpush "timeline:#{follower}", next_post_id
	end

	@redis.lpush "#{@user_id}:posts", next_post_id

	redirect_to :action => "index"
  end

  def follow
    target_user_id = @redis.hget :user_info, "#{params[:id]}:user_id"
	@redis.sadd "#{@user_id}:following", target_user_id
	@redis.sadd "#{@target_user_id}:followers", @user_id

	render :text => "<span style='color:red;font-weight:bold'>팔로우 하였습니다.</span>"
  end

  def signup
    if params[:commit]
	  next_user_id = @redis.incr :next_user_id

	  auth = create_auth

	  # '알고있는 값:입력값'의 Hash 형식으로 등록됨
	  @redis.hset :user_info, "#{next_user_id}:user-name", params[:user_name]
	  @redis.hset :user_info, "#{next_user_id}:password", Digest::SHA256.hexdigest(params[:password])
	  @redis.hset :user_info, "#{next_user_id}:auth", auth
	  @redis.hset :user_info, "#{auth}:user_id", next_user_id
	  @redis.hset :user_info, "#{params[:user_name]}:user_id", next_user_id

	  store_cookie(auth)

	  flash[:msg] = "등록되었습니다"
	  redirect_to :action => "index"
	end
  end

  def login
    if params[:commit]
	  user_id = @redis.hget :user_info, "#{params[:user_name]}:user_id"
	  stored_password = @redis.hget :user_info,, "#{user_id}:password"

	  if stored_password == Digest::SHA256.hexdigest(params[:password])
	    auth = create_auth
		@redis.hset :user_info, "#{user_id}:auth", auth
		@redis.hset :user_info, "#{auth}:user_id", user_id
		store_cookie(auth)
      else
	    # 입력이 틀렸을 경우의 처리
	  end

	  flash[:msg] = "Login하였습니다"
	  redirect_to :action => "index"
	end
  end

  def logout
    @redis.hdel :user_info, "#{user_id}:auth"
	@redis.hdel :user_info, "#{cookies[:auth]}:user_id"
	store_cookie(nil, true)

	flash[:msg] = "Logout하였습니다"
	redirect_to :action => "index"
  end

  def init
    @redis = Redis.new

	if cookies[:auth]
	  @user_id = @redis.hget :user_info, "#{cookies[:auth]}:user_id"
	  @user_name = @redis.hget :user_info, "#{user_id}:user_name"
	end
  end

  def login?
    !@user_id.blank?
  end

  def fetch_timeline
    if login?
	  post_ids = @redis.lrange "timeline:#{@user_id}", 0, 9
	else
	  post_ids = @redis.lrange :timeline, 0, 9
	end

	@timeline = []
	post_ids.each do |post_id|
	  @timeline << @redis.get("post:#{post_id}")
	end
  end

  def fetch_user_posts(user_id)
	post_ids = @redis.lrange "#{user_id}:posts", 0, 9

	@timeline = []
	post_ids.each do |post_id|
	  @timeline << @redis.get("post:#{post_id}")
	end
  end

  def create_auth
    a = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
	Array.new(32){a[rand(a.size)]}.join
  end

  def store_cookie(auth, delete_flag=false)
	# expires를 24시간 후로하여 cookie에 auth라는 이름의 key로 저장
	# 삭제할 경우에는 과거날짜로 설정
	expire = delete_flag? Time.now - 1.day : Time.now + 1.day
	cookies[:auth] = {
	  :value => auth,
	  :expires => Time.gm(expire.year, expire.month, expire.day, expire.hour, expire.min, expire.sec)
	}
  end
end

