require 'handlersocket'

hs_write = HandlerSocket.new('localhost', 9999)

hs_write.open_index(1, 'handlersocket', 'test', 'PRIMARY', 'id,data')
hs_write.execute_insert(1, [4, 'data_4'])
hs_write.execute_delete(1, '=', [2], 1, 0)
res2 = hs_write.execute_single(1, '>=', [1], 10, 2)
p res2	# [0, "3", "data_03", "4", "data_4"]

hs_write.close

