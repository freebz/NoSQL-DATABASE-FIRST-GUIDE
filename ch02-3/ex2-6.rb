require 'rubygems'
require 'redis'

redis = Redis.new

redis.sadd :fuga, 'm1'
redis.sadd :fuga, 'm2'
redis.sadd :fuga, 'm3'

p redis.smembers :fuga		# ["m2", "m3", "m1"]
p redis.scard :fuga			# 3
p redis.spop :fuga			# "m1", "m2", "m3" 중 하나를 반환

