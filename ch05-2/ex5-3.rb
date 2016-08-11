require 'handlersocket'
require 'benchmark'

LIMIT = 20000

def init
  @hs = HandlerSocket.new('localhost', 9999)
  @hs.open_index(1, 'handlersocket', 'users', 'PRIMARY', 'id,user_id,value')
end

def finalize
  @hs.close
end

init

Benchmark.bm do |x|
  x.report('HandlerSocket') {
	1.upto(LIMIT) do |user_id|
	  @hs.execute_insert(1, [user_id, user_id, "value_#{user_id}"])
	end
  }
end

finalize

