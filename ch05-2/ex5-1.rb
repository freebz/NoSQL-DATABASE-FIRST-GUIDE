require 'handlersocket'

hs = HandlerSocket.new

hs.open_index(1, 'handlersocket', 'test', 'PRIMARY', 'id,data')
res = hs.execute_single(1, '=', [2]) # id = 2인 데이터를 읽어온다
p res	# [0, "2", "data_2"]

hs.close

