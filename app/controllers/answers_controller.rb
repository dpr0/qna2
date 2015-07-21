class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy, :update, :best, :perfect, :bullshit, :cancel]
  before_action :load_question_answer, only: [:best, :perfect, :bullshit, :cancel]

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save

    respond_to do |format|
      format.html do
        # if @answer.save
        #  render partial: 'answers/answer', layout: false
        # else
        #  render text: @answer.errors.full_messages.join("\n"), status: :unprocessable_entity
        # end

        if @answer.save
          render json: @answer
        else
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end

      # format.js
    end
  end

  def destroy
    @answer.destroy if @answer.user_id == current_user.id
  end

  def best
    @answer.best_answer
  end

  def perfect
    @answer.increment!(:votes_count)
    @answer.votes << Vote.new(user_id: current_user.id, score: 1)
  end

  def bullshit
    @answer.decrement!(:votes_count)
    @answer.votes << Vote.new(user_id: current_user.id, score: -1)
  end

  def cancel
    @vote = @answer.votes.find_by(user_id: current_user.id)
    if @vote.score == 1
      @answer.decrement!(:votes_count)
    else
      @answer.increment!(:votes_count)
    end
    @vote.destroy if @vote.user_id == current_user.id
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attaches_attributes: [:id, :file, :_destroy])
  end

  def load_question_answer
    @question = @answer.question
  end
end
