require 'tokyotyrant'
include TokyoTyrant

rdb = RDBTBL.new
#rdb.open('localhost', 1978)
rdb.open('127.0.0.1', 1978)

rdb['1'] = {:name => "sant299", :birthday => "19840331"}
rdb['2'] = {:name => "taro", :birthday => "19801119"}
rdb['3'] = {:name => "hana299", :birthday => "19860730"}

query = RDBQRY.new(rdb)
query.addcond("name", RDBQRY::QCSTREW, "299")
query.setorder("birthday", RDBQRY::QONUMDESC)
res = query.search()

# key 값만 반환
p res	# ["3", "1"]

# 구체적인 값을 알기 위해 get을 이용
p rdb.get(res[0])	# {"name"=>"hana299", "birthday"=>"19860730"}
p rdb.get(res[1])	# {"name"=>"sant299", "birthday"=>"19840331"}

# key를 알고 있으면 직접 access도 가능함
p rdb.get('2')	# {"name"=>"taro", "birthday"=>"19801119"}

rdb.close

