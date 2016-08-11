require 'tokyotyrant'

def access_log
  tt = TokyoTyrant::RDB.new
  tt.open('localhost', 1978)

  # 앞부분이 일치하는 KEY를 모두 반환한다
  # 예를 들어 인수로 2를 넣으면, 기사ID가 2로 시작하는 데이터의 Access 수를 모두 찾는다
  keys = @tt.fwmkeys("counter:#{params[:id]}")
  keys.sort {|a,b| a.split(/:/)[-1] <=> b.split(/:/)[-1]}.each do |k|
    p "#{k.split(/:/)[-1]} - #{@tt.get(k).unpack('i').first}"
  end

  tt.close
end

