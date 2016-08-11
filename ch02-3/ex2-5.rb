require 'rubygems'
require 'redis'

# 동시에 여러 클라이언트가 접속했다고 가정
redis = Redis.new
redis2 = Redis.new

# [ "1", "2", "3" ] 이라는 배열 데이터를 입력
redis.lpush :hoge, 3
redis.lpush :hoge, 2
redis.lpush :hoge, 1

redis.rpush :hoge, 4
p redis.lrange :hoge, 0, -1		# ["1", "2", "3", "4"]

redis2.rpush :hoge, 5
p redis2.lrange :hoge, 0, -1	# ["1", "2", "3", "4", "5"]

