require 'tokyotyrant'

def show
  tt = TokyoTyrant::RDB.new
  tt.open('localhost', 1978)

  # ..snip..
  date = params[:date] || Date.today.strftime("%Y%m%d")
  _key = "counter:#{id}:#{date}"  # "기사ID:일자"

  tt.addint(_key, 1)
  @access_count = tt.get(_key).unpack('i').first

  tt.close
end

