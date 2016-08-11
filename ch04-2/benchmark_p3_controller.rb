class RenchmarkP3Controller < ApplicationController
  require 'benchmark'
  require 'mongo_mapper'
  MongoMapper.database = 'mydb'

  LIMIT = 200000
  LIMIT_S = 1000

  class ::Blog < ActiveRecord::Base
    has_many :articles
  end

  class ::Article < ActiveRecord::Base
  end

  class ::BlogMongo
    include MongoMapper::Document
	many :article_mongos
  end

  class ::ArticleMongo
    include MongoMapper::EmbeddedDocument
  end

  def insert
    Benchmark.bm do |x|
	  x.report('MySQL') {
		1.upto(LIMIT) do |num|
		  @blog = Blog.create!(:title => "title_#{num}")
		  1.upto(10) do |num2|
		    @article = Article.create!({
			  :title => "title_#{num2}",
			  :body => "body#{num2}",
			  :blog_id => @blog.id
			})
		  end
		end
	  }
      x.report('MongoDB') {
		1.upto(LIMIT) do |num|
		  @blog_mongo = BlogMongo.new(
			:blog_id => num,
			:title => "title_#{num}"
		  )
		  1.upto(10) do |num2|
		    @blog_mongo.article_mongos << ArticleMOngo.new(
			  :title => "title_#{num2}",
			  :body => "body_#{num2}"
			)
		  end
		  @blog_mongo.save!
		end
	  }
    end

	render :text => "hoge"
  end

  def select
    Benchmark.bm do |x|
	  x.report('MySQL') {
		1.upto(LIMIT_S) do
		  Blog.first(
		    :include => :articles,
			:conditions => ["id = ?", (1 + rand(LIMIT))]
		  ).articles
		end
	  }
      x.report('MongoDB') {
		1.upto(LIMIT_S) do
		  MongoBlog.first(
			:blog_id => (1 + rand(LIMIT))
		  ).article_mongos
		end
	  }
    end

	render :text => "hoge"
  end
end

