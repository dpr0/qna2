class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy, :update, :best, :perfect, :bullshit, :cancel]
  before_action :load_question_answer, only: [:best, :perfect, :bullshit, :cancel]
  after_action :publish_answer, only: [:create]

  respond_to :js
  respond_to :json, only: :create

  authorize_resource

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def destroy
    @answer.destroy
  end

  def best
    @answer.best_answer
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attaches_attributes: [:id, :file, :_destroy]).merge(user_id: current_user.id)
  end

  def publish_answer
    PrivatePub.publish_to("/questions/#{@question.id}/answers", answer: @answer.to_json) if @answer.valid?
  end

  def load_question_answer
    @question = @answer.question
  end
end
