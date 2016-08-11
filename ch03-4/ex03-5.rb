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
  body_h = {
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
	:q_4 => %w(20-29 30-39 40-49 50-59 upper60),
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
    question_list << Question.new(
	  :question_number => "q_#{n}",
	  :body => body_h["q_#{n}".to_sym],
	  :type => type_h["q_#{n}".to_sym],
	  :choices => choices_h["q_#{n}".to_sym],
	  :required_column => require_h["q_#{n}".to_sym]
	)
  end

  enquete.questions = question_list
  enquete.save!

  render :text => "hoge"
end

