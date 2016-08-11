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

