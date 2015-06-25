class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy, :update]

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:notice] = 'Answer delete!'
    else
      flash[:notice] = 'not your answer'
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
