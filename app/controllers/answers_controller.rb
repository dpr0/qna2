class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  def create
    #@answer = @question.answers.build(answer_params)
    #@answer = @question.answers.create(answer_params)
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    #if @answer.save
    #  flash[:notice] = 'Ответ принят.'
      #redirect_to @question
      #redirect_to question_path(@answer.question)
      #render 'questions/show'
    #else
    #  flash[:notice] = 'Error!'
    #  render 'questions/show'
    #end
    #@question
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

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
