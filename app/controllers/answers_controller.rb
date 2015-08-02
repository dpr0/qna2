class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy, :update, :best, :perfect, :bullshit, :cancel]
  before_action :load_question_answer, only: [:best, :perfect, :bullshit, :cancel]

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save

    respond_to do |format|
      #format.html do
      #end
      if @answer.save
        #  render partial: 'answers/answer', layout: false
        #  render json: @answer
        format.js do
          PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json
          render nothing: true
        end
      else
        #  render text: @answer.errors.full_messages.join("\n"), status: :unprocessable_entity
        #  render json: @answer.errors.full_messages, status: :unprocessable_entity
        format.js
        #  do
        #  PrivatePub.publish_to "/questions/#{@question.id}/answers", errors: @answer.errors.full_messages
        #  render nothing: true
        #end
      end
    end
  end

  def destroy
    @answer.destroy if @answer.user_id == current_user.id
  end

  def best
    @answer.best_answer
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attaches_attributes: [:id, :file, :_destroy])
  end

  def load_question_answer
    @question = @answer.question
  end
end
