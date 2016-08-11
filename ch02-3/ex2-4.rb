require 'rubygems'
require 'redis'
require 'json'

redis = Redis.new

json = [1, 2, 3].to_json
redis.set :number, json
p JSON.parse(redis.get :number)	# [1, 2, 3]

