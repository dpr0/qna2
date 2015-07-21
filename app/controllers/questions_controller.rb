class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy, :upvote, :perfect, :bullshit, :cancel]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attaches.build
  end

  def new
    @question = Question.new
    @question.attaches.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    # @question.user_id = @user.id
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:notice] = 'Ok!'
      redirect_to @question
    else
      flash[:notice] = 'Error!'
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash[:notice] = 'Ok!'
      redirect_to @question
    else
      flash[:notice] = 'Error!'
      render :edit
    end
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy
      flash[:notice] = 'Question delete!'
      redirect_to questions_path
    else
      flash[:notice] = 'not your question'
      render :show
    end
  end

  def perfect
    @question.increment!(:votes_count)
    @question.votes << Vote.new(user_id: current_user.id, score: 1)
  end

  def bullshit
    @question.decrement!(:votes_count)
    @question.votes << Vote.new(user_id: current_user.id, score: -1)
  end

  def cancel
    @vote = @question.votes.find_by(user_id: current_user.id)
    if @vote.score == 1
      @question.decrement!(:votes_count)
    else
      @question.increment!(:votes_count)
    end
    @vote.destroy if @vote.user_id == current_user.id
  end

  def upvote
    # user  = current_user.id
    # array = []
    # arr = @question.votes_count.split(',')
    # arr.each{ |i| array << i.to_i }
    # if array.include?(user)
    #  array = array - [user]
    # else
    #  array << user
    # end
    # @question.update_attributes!( votes_count: array.join(',') )
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attaches_attributes: [:id, :file, :_destroy])
  end
end
