require 'rubygems'
require 'memcache'

cache = MemCache.new(['localhost:11211'])

# [1, 2, 3]이라는 배열 형식 데이터를 입력
cache['hoge'] = [1, 2, 3]

# 다수가 접속하고 있다고 가정
# 프로세스1이 array_1, 프로세스 2가 array2
array_1 = cache['hoge']
array_2 = cache['hoge']

array_1 << 4 # 프로세스 1에 4를 추가
array_2 << 5 # 프로세스 2에 5를 추가

cache['hoge'] = array_1
p cache['hoge'] # [1, 2, 3, 4]

cache['hoge'] = array_2
p cache['hoge'] # [1, 2, 3, 5]

