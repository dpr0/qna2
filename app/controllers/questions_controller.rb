class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :perfect, :bullshit, :cancel]
  before_action :build_answer, only: [:show]

  respond_to :json

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with (@question = Question.new)
  end

  def edit
  end

  def create
    respond_with (@question = current_user.questions.create(question_params))
    PrivatePub.publish_to '/questions/new', question: @question.to_json if @question.save
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    # if @question.user_id == current_user.id
    respond_with (@question.destroy)
  end

  private

  def build_answer
    @answer = @question.answers.build
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attaches_attributes: [:id, :file, :_destroy])
  end
end
