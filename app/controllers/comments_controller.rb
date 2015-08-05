class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
  #  @question = @answer.question
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      if params[:question_id]
        PrivatePub.publish_to "/questions/#{@question.id}/comments", comment: @comment.to_json
      else
        PrivatePub.publish_to "/answers/#{@answer.id}/comments", comment: @comment.to_json
      end
      render nothing: true
    else
      render json: @comment.errors.full_messages.join("\n"), status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if @comment.user_id == current_user.id
  end

  private

  def load_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
      @question = @commentable
    else
      @commentable = Answer.find(params[:answer_id])
      @answer = @commentable
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end