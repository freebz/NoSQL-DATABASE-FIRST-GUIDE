require 'rubygems'
require 'memcache'

cache = MemCache.new(['localhost:11211'])

# [1, 2, 3]이라는 배열 형식 데이터를 입력
cache['hoge'] = [1, 2, 3]

# 여러 클라이언트에서 접속했다고 가정
#retry if cache.cas('hoge') {|value| value << 4} !~ /^STORED/
#retry if cache.cas('hoge') {|value| value << 5} !~ /^STORED/

while true
  break if not cache.cas('hoge') {|value| value << 4} !~ /^STORED/
end

while true
  break if not cache.cas('hoge') {|value| value << 5} !~ /^STORED/
end

p cache['hoge'] # [1, 2, 3, 4, 5]

