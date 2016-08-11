require 'rubygems'
require 'mongo'

connection = Mongo::Connection.new("localhost", 27017)
db = connection.db("mydb")	# mydb 데이터베이스에 접속

p db.collection_names	# [] 이 시점에서는 콜렉션이 없음

coll = db.collection("users")

# 데이터 입력
(201..300).each {|n| coll.insert(:name => "santa#{n}")}

p db.collection_names	# ["users", "system.indexes"]
p coll.count	# 100

# name이 "santa299"인 데이터를 출력
coll.find(:name => "santa299").each {|row| p row}
# {"_id"=>BSON::ObjectId('4e8522a7e138235e6b000063'), "name"=>"santa299"}

# name이 0으로 끝나는 데이터를 5건 출력
coll.find(:name => /0$/).limit(5).each {|row| p row}
# {"_id"=>BSON::ObjectId('4e8522a7e138235e6b000063'), "name"=>"santa210"}
# {"_id"=>BSON::ObjectId('4e8522a7e138235e6b000014'), "name"=>"santa220"}
# {"_id"=>BSON::ObjectId('4e8522a7e138235e6b00001e'), "name"=>"santa230"}
# {"_id"=>BSON::ObjectId('4e8522a7e138235e6b000028'), "name"=>"santa240"}
# {"_id"=>BSON::ObjectId('4e8522a7e138235e6b000032'), "name"=>"santa250"}

# mydb 데이터베이스를 삭제한다
connection.drop_database("mydb")

