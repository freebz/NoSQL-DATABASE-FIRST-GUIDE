class BenchmarkP1Controller < ApplicationController
  before_filter :init
  after_filter :finalize

  require 'benchmark'
  require 'memcache'
  require 'tokyotyrant'

  LIMIT = 100000

  def index
    Benchmark.bm do |x|
	  x.report('addint') {
		1.upto(LIMIT) do
		  @tt.addint("counter", 1)
		  @tt.get("counter").unpack('i').first
		end
	  }
      x.report('incr') {
		1.upto(LIMIT) do
		  _counter = @tt_mem.incr("counter")
		  if !_counter
			@tt_mem.set("counter", 0)
			@tt_mem.incr("counter")
		  end
		end
	  }
    end

	render :text => "hoge"
  end

  private

  def init
    @tt = TokyoTyrant::RDB.new
	@tt.open('localhost', 1978)

	@tt_mem = MemCache.new(['localhost:1979'])
  end

  def finalize
    @tt.close
  end
end


