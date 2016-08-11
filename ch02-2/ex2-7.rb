require 'rubygems'
require 'active_record'
require 'active_tokyocabinet/tdb'

ActiveRecord::Base.establish_connection(
  :adapter => 'tokyotyrant',
  :database => {
    :users => {:host => 'localhost', :port => 1978},
  }
)

class User < ActiveRecord::Base
  include ActiveTokyoCabinet::TDB

  string :name
  int :age
end

user User.new(:name => "santa299")
user.age = 27
user.save

p User.count # 1
user = User.find(
  :first,
  :conditions => ["name = ? AND age = ?", "santa299", 27], # OR 검색은 불가능
  :order => "age DESC",
  :limit => 10
)

p user	# #<User id: 1, name: "santa299", age: "27">

