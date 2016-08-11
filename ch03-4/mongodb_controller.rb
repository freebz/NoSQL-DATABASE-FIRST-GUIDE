class MongodbController < ApplicationController
  require 'mongo_mapper'
  MongoMapper.database = 'mydb'

  def index
    @enquetes = Enquete.all
  end

  def show
    @enquete = Enquete.find(params[:id])
  end

  def create
    if params[:commit]
	  questions = Enquete.find(params[:answer][:enquete_id]).questions

	  @err_msg = {}
	  questions.each do |q|
	    if q.required_column && params[:answer][q.question_number].blank?
		  @err_msg[q.question_number] = "no data"
	    end
	  end

	  if @err_msg.blank?
	    answer = Answer.new(params[:answer])
	    answer.save!
	    flash[:msg] = "Answer is accepted"
	    redirect_to :action => 'show', :id => params[:answer][:enquete_id]
	  else
	    @enquete = Enquete.find(params[:answer][:enquete_id])
	    render :action => 'show'
	  end
    end
  end

  def list
    @answers = Answer.all
  end

  def create_answer
    10.times do
	  condition = {}
	  (1..12).each do |n|
	    if rand(100) % 4 == 1
		  condition["q_#{n}"] = "a_#{n}"
		elsif rand(100) % 4 == 2
		  condition["q_#{n}"] = "a\nb_#{n}"
		elsif rand(100) % 4 == 3
		  condition["q_#{n}"] = 1 + rand(5)
		else
		  list = [1, 2, 3, 4, 5]
		  condition["q_#{n}"] = list.sort_by{rand}[0..rand(5)]
		end
	  end

	  Answer.create(
		condition.merge(
		  :user_id => 1,
		  :enquete_id => 1
		)
	  )
	end

	render :text => "hoge"
  end

  def create_question
    enquete = Enquete.new(
	  :name => "An Enquete about Sports & Liquor"
	)

	question_list = []
	type_h = {
	  :q_1 => 'text',
	  :q_2 => 'checkbox',
	  :q_3 => 'radio',
	  :q_4 => 'pulldown',
	  :q_5 => 'textarea'
	}
	hody_h = {
	  :q_1 => "What is your favorite sports?",
	  :q_2 => "What is your favorite type of liquor?(multiple answers)",
	  :q_3 => "Check your gender",
	  :q_4 => "Age?",
	  :q_5 => "How did you know about this survey?"
	}
	choices_h = {
	  :q_1 => nil,
	  :q_2 => %w(
		none
		beer
		sake
		soju
		wine(red)
		wine(white)
		cocktail
		whiskey
	  ),
	  :q_3 => %w(mail femail),
	  :q_4 => %w(20~29 30~39 40~49 50~59 upper60),
	  :q_5 => nil
	}
	require_h = {
      :q_1 => true,
	  :q_2 => true,
	  :q_3 => true,
	  :q_4 => true,
	  :q_5 => false
	}
    
    (1..5).each do |n|
	  qeustion_list << Question.new(
	    :question_number => "q_#{n}",
		:body => body_h["q_#{n}".to_sym],
		:type => type_h["q_#{n}".to_sym],
		:choices => type["q_#{n}".to_sym],
		:required_column => required_h["q_#{n}".to_sym]
	  )
	end

	enquete.questions = question_list
	enquete.save!

	render :text => "hoge"
  end
end




