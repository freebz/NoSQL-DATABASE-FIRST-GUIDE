class TokyoTyrant2Controller < ApplicationController
  before_filter :init
  after_filter :finalize

  require 'tokyotyrant'

  def show
    @data = Marshal.load(@tt.get(params[:id])) if @tt.get(params[:id])

	if !@data
	  create_cache(params[:id])
	end

	# Access수를 가져온다
	@access_count = access_count(params[:id])
  end

  def access_log
    # 앞부분이 일치하는 KEY를 모두 반환한다
    # 예를 들어 인수가 2라면, 기사ID가 2로 시작하는 데이터의 Access 수를 모두 찾는다
    keys = @tt.fwmkeys("counter:#{params[:id]}")
	keys.sort {|a,b| a.split(/:/)[-1] <=> b.split(/:/)[-1]}.each do |k|
	  p "#{k.split(/:/)[-1]} - #{@tt.get(k).unpack('i').first}"
	end

	render :text => "hoge"
  end

  private

  def init
    @tt = TokyoTyrant::RDB.new
	@tt.open('localhost', 1978)
  end

  def finalize
    @tt.close
  end

  def create_cache(id, mem_flag = false)
	article = Article.find(params[:id])
	tags = Tag.find_all_by_article_id(params[:id]).map(&:body)
	comments = Comment.find_all_by_article_id(params[:id]).map(&:body)
	@data = {
	  :title => article.title,
	  :body => article.body,
	  :created_at => article.created_at.strftime("%Y-%m-%d %H:%M:%S"),
	  :tags => tags,
	  :comments => comments
	}

    @tt.put(params[:id], Marshal.dump(@data))
  end

  def access_count(id)
	date = params[:date] || Date.today.strftime("%Y%m%d")
	_key = "counter:#{id}:#{date}"

	@tt.addint(_key, 1)  # Access수에 1을 더한다
	@tt.get(_key).unpack('i').first  # 1을 더한 후의 수치를 가져온다
  end
end

