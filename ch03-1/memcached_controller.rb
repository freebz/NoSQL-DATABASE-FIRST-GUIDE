class MemcachedController < ApplicationController
  before_filter :init

  require 'rubygems'
  require 'memcache'

  def create
    (1..10).each do |n|
	  Article.create!(:title => "title_#{n}", :body => "body_#{n}")
	  (1 + rand(3)).times do |i|
	    Tag.create!(:name => "tag_#{n}_#{i + 1}", :article_id => n)
	  end
	  (1 + rand(5)).times do |j|
	    Comment.create!(:body => "comment_#{n}_#{j + 1}", :article_id => n)
	  end
	end

	render :text => "hoge"
  end

  def show
    @data = @cache[params[:id]]

	if !@data || data_change?
	  create_cache(params[:id])
	end
  end

  private

  def init
    @cache = MemCache.new(['localhost:11211'])
  end

  def create_cache(id)
	article = Article.find(id)
	tags = Tag.find_all_by_article_id(id).map(&:name)
	comments = Comment.find_all_by_article(id).map(&:body)

	@data = {
	  :title => article.title,
	  :body => article.body,
	  :created_at => article.created_at.strftime("%Y-%m-%d %H:%M:%S"),
	  :tags => tags,
	  :comments => comments
	}

    @cache.set(id, @data, 86400)
  end

  def data_change?
    !!@change_flag
  end

  def update_article

    @change_flag = true
  end

  def update_tags(article_id)

	@change_flag = true
  end

  def update_comments(article_id)

	@change_flag = true
  end
end

		  
