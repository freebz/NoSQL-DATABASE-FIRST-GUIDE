require 'rubygems'
require 'miyazakiresistance'

class User < MiyazakiResistance::Base
  #set_server "localhost", 1978, :write
  set_server "127.0.0.1", 1978, :write

  set_column :name, :string
  set_column :age, :string
  set_column :created_at, :datetime
end

user = User.new(:name => "santa299")
user.age = 27
user.save

p User.count # 1

# 검색 조건은 반드시 AND 검색됨
user = User.find(
  :first,
  :conditions => ["name = ? age = ?", "santa299", 27],
  :order => "created_at DESC",
  :limit => 10
)
p user #<User:0xb7e96788 @id=-1, @created_at=Thu Sep 29 10:00:57 -0700 2011, @name="santa299", @age27>

