require 'memcache'

date = parse[:date] || Date.today.strftime("%Y%m%d")
cache = MemCache.new

cache.set(date, @data, 86400) # expires는 60x60x24, 즉 24시간 후로 지정함

