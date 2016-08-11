$KCODE = 'u'

require "rubygems"
require "memcache"

server = ['localhost:11211']	# 이용할 memcached를 지정

option = {}

cache = MemCache.new(server, option)

# 데이터 입력
cache['key1'] = 123							# 숫자
cache['key2'] = "abcde"						# 문자열
cache['key3'] = %w(hoge fuga)				# 배열
cache['key4'] = {:foo => 1, :bar => "a" }	# hash

# 데이터 읽어오기
p cache['key1']		# 123
p cache['key2']		# "abcde"
p cache['key3']		# ["hoge", "fuga"]
p cache['key4']		# {:foo=>1, :bar=>"a"}

