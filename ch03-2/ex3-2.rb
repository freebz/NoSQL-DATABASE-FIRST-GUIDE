require 'tokyotyrant'

def show_mem
  mem = MemCache.new('localhost:1979')

  @data = mem.get(params[:id])

  if !@data
    article = Article.find(params[:id])
	tags = Tag.find_all_by_article_id(params[:id]).map(&:name)
	comments = Comment.find_all_by_article_id(params[:id]).map(&:body)
	@data = {
	  :title => artitle.title,
	  :body => article.body,
	  :created_at => article.created_at.strftime("%Y-%m-%d %H:%M:%S"),
	  :tags => tags,
	  :comments => comments
	}

    mem.set(params[:id], @data)
  end

  # 접속자 수를 가져온다.
  # 데이터가 없을 경우에는 명시적으로 값에 0을 저장한다
  @access_count = mem.incr("counter:#{params[:id]}")
  if !@access_count
    mem.set("counter:#{params[:id]}", 0)
	@access_count = mem.incr("counter:#{params[:id]}")
  end

  render :action => "show"
end

