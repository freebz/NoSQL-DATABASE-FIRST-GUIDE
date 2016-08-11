require 'redis'

def post
  redis = Redis.new

  if cookies[:auth]
    @user_id = Redis.hget :user_info, "#{cookies[:auth]}:user_id"
  end

  # 등록ID 생성
  next_post_id = @redis.incr :next_post_id

  # 데이터를 입력한다
  redis.set "post:#{next_post_id}", "#{@user_id}|#{Time.now.to_s(:db)}|#{params[:message]}"

  # 모든 사용자의 twit을 모은 타임라인에 등록ID를 추가한다
  redis.lpush :timeline, next_post_id

  # 팔로워(당신을 팔로우 한 사용자)의 사용자ID를 가져와서
  # 본인을 포함한 사용자의 타임라인에 등록ID를 추가한다
  followers = redis.smembers "#{@user_id}:followers"
  followers << @user_id
  followers.each do |follower|
    redis.lpush "timeline:#{follower}", next_post_id
  end

  # 본인의 posts에도 등록ID를 추가한다
  redis.lpush "#{@user_id}:posts", next_post_id

  redirect_to :action => "index"
end

