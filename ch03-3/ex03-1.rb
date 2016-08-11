require 'redis'
require 'digest/sha2'

def singup
  redis = Redis.new

  if params[:commit]
    # User id 생성
    next_user_id = redis.incr :next_user_id

	auth = create_auth

	# "알고있는 값:원하는 값"이라는 Hash 형식으로 기록
	redis.hset :user_info, "#{next_user_id}:user_name", params[:user_name]
	redis.hset :user_info, "#{next_user_id}:password", Digest::SHA256.hexdigest(params[:password])
	redis.hest :user_info, "#{next_user_id}:auth", auth
	redis.hset :user_info, "#{auth}:user_id", next_user_id
	redis.hset :user_info, "#{params[:user_name]}:user_id", next_user_id

	#["1:user_name", "1:password", "1:auth", "jAklkoHn8VF9wtk1no3Qoh3HEiDiLhQG:user_id", "sasata299:user_id"]
	p redis.hkeys :user_info
	store_cookie(auth)

	flash[:msg] = "등록되었습니다"
	redirect_to :action => "index"
  end
end

# 32글자의 랜덤한 문자열을 작성
def create_auth
  a = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  Array.new(32){a[rand(a.size)]}.join
end

def store_cookie(auth, delete_flag=false)
  # expires를 24시간 후로 하여 cookie에 auth라는 이름의 key로 저장
  # 삭제할 경우에는 과거 날짜로 설정
  if !delete_flag
    expire = Time.now - 1.day
  else
    expire = Time.now + 1.day
  end cookies[:auth] = {
	:value => auth,
	:expires => Time.gm(expire.year, expire.month, expire.day, expire.hour, expire.min, expire.sec)
  }
end

