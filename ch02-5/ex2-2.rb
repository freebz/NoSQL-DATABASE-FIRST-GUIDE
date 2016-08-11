require 'rubygems'
require 'cassandra'
include Cassandra::Constants

client = Cassandra.new('TEST2', '127.0.0.1:9160')

p client.servers # ["127.0.0.1:9160"]

cf_def = CassandraThrift::CfDef.new(:keyspace => "TEST2", :name => "Users",
		:comparator_type => "UTF8Type")
client.add_column_family(cf_def)  # cf_def에 정의한 Column family 추가

1.upto(100) do |n|
client.insert(:Users, n.to_s, {'number' => "#{n}", 'user_id' => "ID#{n}")
end

p client.multi_get(:Users, [1.to_s, 5.to_s, 3.to_s, 7.to_s])
# {"7"=>#<OrderedHash {"number"=>"7", "user_id"=>"ID7"}, "1"=>#<OrderedHash
# {"number"=>"1", "user_id"=>"ID1"}, "3"=>#<OrderedHash {"number"="3",
# "user_id"=>"ID3"}, "5"=>#<OrderedHash {"number"=>"5", "user_id"=>"ID5"}
p client.get_range_keys(:Users, {:key_count => 2})	# ["27", "83"], 2개 key값 반환

