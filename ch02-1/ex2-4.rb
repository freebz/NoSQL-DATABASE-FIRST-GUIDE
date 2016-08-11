require "rubygems"
require "memcache"

cache = MemCache.new(['localhost:11211'])

(1..10).each do |i|
  cache["key_#{i}"] = "value_#{i}"
end

(11..20).each do |i|
  cache["key_#{i}"] = "value_#{('a'..'z').to_a.join('')}_#{i}"
end

