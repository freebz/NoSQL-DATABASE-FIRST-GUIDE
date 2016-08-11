require 'memcache'

def show
  cache = MemCache.new(['localhost:11211'])

# 먼저 memcached에 데이터가 있는지 확인
  data = cache[params[:id]]

# memcached에 데이터가 없으면 관계형 데이터베이스에서
# 읽어와서 memcached에 cache되도록 함
  unless data
    data =Article.find(params[:id])
	cache.set(params[:id], data, 3600)	# expires는 1시간(60*60)
  end
end

