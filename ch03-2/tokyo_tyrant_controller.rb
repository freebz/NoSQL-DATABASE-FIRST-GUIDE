class TokyoTyrantController < ApplicationController
  before_filter :init
  after_filter :finalize

  require 'tokyotyrant'
  require 'memcache'

  def show
    @data = Marshal.load(@tt.get(params[:id])) if @tt.get(params[:id])

	if !@data
	  create_cache(params[:id])
	end

    # 접속자 수를 가져온다
	@access_count = access_count(params[:id])
  end

  def show_mem
    @data = @mem.get(params[:id])

	if !@data
	  create_cache(params[:id])
	end

	# 접속자 수를 가져온다
	@access_count = access_count(params[:id], true)

	render :action => "show"
  end

  private

  def init
    @tt = TokyoTyrant::RDB.new
	@tt.open('localhost', 1978)

	@mem = MemCache.new('localhost:1979')
  end

  def finalize
    @tt.close
  end

  def create_cache(id, mem_flag = false)
	article = Article.find(params[:id])
	tags = Tag.find_by_article_id(params[:id]).map(&:name)
	comments = Comment.find_all_by_article_id(params[:id]).map(&:body)
	@data = {
	  :title => article.title,
	  :body => article.body,
	  :created_at => article.created_at.strftime("%Y-%m-%d %H:%M:%S"),
	  :tags => tags,
	  :comments => comments
	}

    if mem_flag
	  @mem.set(params[:id], @data)
	else
	  @tt.put(params[:id], Marshal.dump(@data))
	end
  end
  def access_count(id, mem_flag = false)
	_key = "counter:#{id}"

	if mem_flag
	  result = @mem.incr(_key)
      if !result
	    @mem.set(_key, 0)
        result = @mem.incr(_key)
	  end
	  result
    else
	  @tt.addint(_key, 1)
	  @tt.get(_key).unpack('i').first
	end
  end
end

