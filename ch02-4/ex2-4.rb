require 'rubygems'
require 'mongo'

connection = Mongo::Connection.new("localhost", 27017)
db = connection.db("test")
coll = db.collection("users")

(1..300000).each {|n| coll.insert(:user_id => n, :name => "user_#{n}")}

