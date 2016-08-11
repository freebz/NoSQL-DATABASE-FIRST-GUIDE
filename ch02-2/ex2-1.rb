require 'tokyotyrant'

rdb = TokyoTyrant::RDB.new
#rdb.open('localhost', 1978)
rdb.open('127.0.0.1', 1978)

p rdb

# 데이터 입력
rdb.put('hoge', 'fuga')

# 아래와 같이 Hash 형식으로 입력도 가능
# rdb['hoge'] = 'fuga'

# 데이터 읽어오기
p rdb.get('hoge')		# "fuga"

# 아래와 같이 Hash 형식 출력도 가능
# p rdb['hoge']

rdb.close

