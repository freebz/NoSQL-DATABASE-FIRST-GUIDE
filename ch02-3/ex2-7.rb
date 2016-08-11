# redis_multi_sample.rb

require 'rubygems'
require 'redis'
require 'redis/distributed'

redis = Redis::Distributed.new %W(redis://localhost:6379 redis://localhost:6380 redis://localhost:6381)

(1..20).each do |n|
  redis.set "key_#{n}", "value_#{n}"
end

redis.ring.nodes.each do |node|
  p "#{node.client.host}:#{node.client.port}: #{node.keys("*").join(', ')}"
end

