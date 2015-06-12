class AnswersController < ApplicationController
  before_action :authenticate_user!
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Ответ принят.'
      redirect_to @question
    else
      flash[:notice] = 'Error!'
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:notice] = 'Answer delete!'
      redirect_to @answer.question
    else
      flash[:notice] = 'not your answer'
      redirect_to @answer.question
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
