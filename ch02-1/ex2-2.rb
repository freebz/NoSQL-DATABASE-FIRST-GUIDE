require "rubygems"
require "memcache"

cache = MemCache.new(['localhost:11211'])

cache.set('key', 'value', 10)	# expires는 10초
p cache['key']		# 'value'

sleep 10

p cache['key']		# nil (10초 후 expire됨)

