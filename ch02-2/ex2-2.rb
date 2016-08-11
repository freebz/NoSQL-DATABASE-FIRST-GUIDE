require 'rubygems'
require 'memcache'

tt = MemCache.new(['localhost:1978']) # 포트 번호가 다릅니다

tt['hoge'] = 'fuga'
p tt['hoge'] # "fuga"

