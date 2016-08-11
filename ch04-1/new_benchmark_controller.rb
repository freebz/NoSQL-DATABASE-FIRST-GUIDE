class NewBenchmarkController < ApplicationController
  before_filter :init
  after_filter :finalize

  require 'benchmark'
  require 'memcache'
  require 'tokyotyrant'
  require 'redis'
  require 'mongo_mapper'
  MongoMapper.database = 'mydb'

  LIMIT = 20000

  class Hoge < ActiveRecord::Base
  end

  class Fuga < ActiveRecord::Base
  end

  class ::Foo
    include MongoMapper::Document
  end

  def insert
    Benchmark.bm do |x|
	  x.report('InnoDB') {
		1.upto(LIMIT) do |user_id|
		  Hoge.create!(:user_id => user_id, :value => "value_#{user_id}")
		end
	  }
      x.report('MyISAM') {
		1.upto(LIMIT) do |user_id|
		  Fuga.create!(:user_id => user_id, :value => "value_#{user_id}")
		end
	  }
      x.report('memcached') {
		1.upto(LIMIT) do |user_id|
		  @mem[user_id.to_s] = "value_#{user_id}"
		end
	  }
      x.report('Tokyo Tyrant(mem)') {
		1.upto(LIMIT) do |user_id|
		  @tt_mem[user_id.to_s] = "value_#{user_id}"
		end
	  }
      x.report('Tokyo Tyrant') {
		1.upto(LIMIT) do |user_id|
		  @tt[user_id.to_s] = "value_#{user_id}"
		end
	  }
      x.report('Redis') {
		1.upto(LIMIT) do |user_id|
		  @redis.set user_id.to_s, "value_#{user_id}"
		end
	  }
      x.report('MongoDB') {
		1.upto(LIMIT) do |user_id|
		  Foo.create!(:user_id => user_id, :value => "value_#{user_id}")
		end
	  }
    end

	render :text => "hoge"
  end

  def select
    Benchmark.bm do |x|
	  x.report('InnoDB') {
		1.upto(LIMIT) do
		  user_id = 1 + rand(LIMIT)
		  Hoge.first(:conditions => ["user_id = ?", user_id]).value
	    end
	  }
      x.report('MyISAM') {
		1.upto(LIMIT) do
		  user_id = 1 + rand(LIMIT)
		  Fuga.first(:conditions => ["user_id = ?", user_id]).value
		end
	  }
      x.report('memcached') {
		1.upto(LIMIT) do
		  user_id = 1 + rand(LIMIT)
		  @mem[user_id.to_s]
		end
	  }
      x.report('Tokyo Tyrant(mem)') {
		1.upto(LIMIT) do
		  user_id = 1 + rand(LIMIT)
		  @tt_mem[user_id.to_s]
		end
	  }
      x.report('Tokyo Tyrant') {
		1.upto(LIMIT) do
		  user_id = 1 + rand(LIMIT)
		  @tt[user_id.to_s]
		end
	  }
      x.report('Redis') {
		1.upto(LIMIT) do
		  user_id = 1 + rand(LIMIT)
		  @redis.get user_id.to_s
		end
	  }
      x.report('MongoDB') {
		1.upto(LIMIT) do
		  user_id = 1 + rand(LIMIT)
		  Foo.first(:user_id => user_id).value
		end
	  }
    end

	render :text => "hoge"
  end 

  private

  def init
    @mem = MemCache.new(['localhost:11211'])
	@tt_mem = MemCache.new(['localhost:1979'])
	@tt = TokyoTyrant::RDB.new
	@tt.open('localhost', 1978)

	@redis = Redis.new
  end

  def finailize
    @tt.close
  end
end

		  



