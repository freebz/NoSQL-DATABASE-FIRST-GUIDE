class BenchmarkP2Controller < ApplicationController
  before_filter :init

  require 'benchmark'
  require 'redis'

  class List < ActiveRecord::Base
  end

  LIMIT = 100000

  def index
    Benchmark.bm do |x|
	  x.report('MySQL') {
		1.upto(LIMIT) do |num|
		  List.create!(:data => "data_#{num}")
		  List.all(:order => "id DESC", :limit => 10)
		end
	  }
      x.report('Redis') {
		1.upto(LIMIT) do |num|
		  @redis.lpush :list, "data_#{num}"
		  @redis.lrange :list, 0, 9
		end
	  }
    end

	render :text => "hoge"
  end

  private

  def init
    @redis = Redis.new
  end
end

