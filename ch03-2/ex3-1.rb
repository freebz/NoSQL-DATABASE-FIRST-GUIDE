require 'tokyotyrant'

def show
  # Tokyo Tyrant 단독 프로토콜 이용
  tt = TokyoTyrant::RDB.new
  tt.open('localhost', 1978)
  @data = Marshal.load(tt.get(params[:id])) if tt.get(params[:id])

  if !@data
    article = Article.find(params[:id])
	tags = Tag.find_all_by_article_id(params[:id]).map(&:name)
	comments = Comment.find_all_by_article_id(params[:id]).map(&:body)
	@data = {
	  :title => article.title,
	  :body => article.body,
	  :created_at => article.created_at.strftime("%Y-%m-%d %H:%M:%S"),
	  :tags => tags,
	  :comments => comments
	}

    tt.put(params[:id], Marshal.dump(@data))
  end

  # Access 수에 1을 더한다
  tt.addint("counter:#{params[:id]}", 1)

  # Access 수 취득
  @access_count = tt.get("counter:#{params[:id]}").unpack('i').first

  tt.close
end

