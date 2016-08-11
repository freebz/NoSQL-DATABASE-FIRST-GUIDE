require 'tokyotyrant'

rdb = TokyoTyrant::RDB.new
#rdb.open('localhost', 1978)
rdb.open('127.0.0.1', 1978)

rdb.put('hoge', 'fuga')
rdb.put('foo', 'bar')
rdb.put('test_1', 'data_1')
rdb.put('test_2', 'data_2')
rdb.put('test_3', 'data_3')

# 데이터 유무 확인
p rdb.has_key?('test_3') # true
p rdb.has_key?('test_4') # false

# 존재하는 key를 모두 보기
# ["foo", "hoge", "hog", "test_1", "test_2", "test_3"]
p rdb.keys

# 앞부분이 일치하는 key를 모두 반환
# ["test_1", "test_2", "test_3"]
p rdb.fwmkeys('test')

# 전체 데이터를 삭제
p rdb.vanish

rdb.close

