require 'handlersocket'
require 'benchmark'

LIMIT = 20000

def init
  @hs = HandlerSocket.new('localhost', 9999)
  @hs.open_index(1, 'handlersocket', 'users', 'user_id', 'id,user_id,value')
end

def finalize
  @hs.close
end

init

Benchmark.bm do |x|
  x.report('HandlerSocket') {
	1.upto(LIMIT) do |user_id|
	  user_id = 1 + rand(LIMIT)
	  @hs.execute_single(1, '=', [user_id])[3]
	end
  }
end

finalize

