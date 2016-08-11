require 'rubygems'
require 'cassandra'
include Cassandra::Constants

client = Cassandra.new('TEST', '127.0.0.1:9160')  # 접속

# 접속한 node에서 사용할 수 있는 Keyspace 목록을 출력
p client.keyspaces	# ["TEST", "system", "keyspace1"]

# 데이터 입력
client.insert(:User, 'HJLee',{'height' => '160', 'first' => 'Heejin'})

# RowKey가 'HJLee'인 데이터를 출력
p client.get(:User, 'HJLee') # #<OrderedHash {"height"=>"160", "first"=>"Heejin"}

# 해당 RowKey에서 가지고 있는 컬럼 수를 출력
p client.count_columns(:User, 'HJLee')	# 2

# 해당 RowKey와 일치하는 row의 특정 컬럼값을 출력
p client.get_columns(:User, 'HJLee', ['first'])		# ["Heejin"]

# 해당 RowKey의 데이터를 삭제
client.remove(:User,'HJLee')

# 해당 RowKey 존재 여부 확인
p client.exists?(:User, 'HJLee') # false

