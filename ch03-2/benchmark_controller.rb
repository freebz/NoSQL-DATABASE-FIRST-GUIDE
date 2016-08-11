class BenchmarkController < ApplicationController
  before_filter :init
  after_filter :finalize

  require 'benchmark'
  require 'tokyotyrant'

  def test
    Benchmark.bm do |x|
	  x.report('MySQL') {
		1.upto(10000) do |num|
		  counter = Counter.find(1) rescue Counter.create!
		  counter.count += 1
		  counter.save!
		end
	  }
      x.report('Tokyo Tyrant') {
		1.upto(10000) do |num|
		  @tt.addint(1, 1)
		end
	  }
	render :text => "hoge"
  end

  private

  def init
    @tt = TokyoTyrant::RDB.new
	@tt.open('localhost', 1978)
  end

  def finalize
    @tt.close
  end
end

