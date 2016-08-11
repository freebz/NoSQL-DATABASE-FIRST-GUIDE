require 'rubygems'
require 'redis'

redis = Redis.new

redis.set :number, 1
result = redis.get :number

p result	# "1"
p result.class	# String

