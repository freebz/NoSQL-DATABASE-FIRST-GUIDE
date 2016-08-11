require 'memcache'

def show
  cache = MemCache.new('[localhost:11211'])

  data = cache[params[:id]]

# 데이터가 memcached에 없거나 아니면 갱신된 경우
  if !data || data_change?
    article = Article.find(id)
	tags = Tag.find_all_by_article_id(id).map(&:name)
	comments = Comment.find_all_by_article_id(id).map(&:body)
	@data = {
	  :title => article.title,
	  :body => article.body,
	  :created_at => article.created_at.strftime("%Y-%m-%d %H:%M:%S"),
	  :tags => tags,
	  :comments => comments
	}

    cache.set(id, @data, 86400)  # expires는 24시간(60x60x24) 후
  end
end

def data_change?
  !!@change_flag
end

def update_article
# 블로그 포스팅을 수정

  @change_flag = true
end

def update_tags(article_id)
# 태그를 수정

  @change_flag = true
end

def update_comments(article_id)
# 코멘트를 갱신

  @change_flag = true
end

