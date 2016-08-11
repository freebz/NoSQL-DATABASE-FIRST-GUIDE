require 'rubygems'
require 'mongo_mapper'

MongoMapper.database = 'mydb'

class User
  include MongoMapper::Document

  key :name, String
  key :age, Integer
  key :created_at, Time
end

User.create(:user => "santa299", :age => "27ab", :created_at => Time.now)
p User.first ##<User _id: BSON::ObjectId('4e85e2a8e1382341aa000001'), age: 27, created_at: Fri Sep 30 15:39:20 UTC 2011, name: "santa299">

