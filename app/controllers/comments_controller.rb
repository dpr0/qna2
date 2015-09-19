class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_parent, only: :create
  before_action :load_comment, only: [:update, :destroy]
  after_action :publish_comment, only: [:create]

  respond_to :json, only: :create
  respond_to :js

  authorize_resource

  def update
    #authorize! :update, @comment
    @comment.update(comment_params)
    respond_with @comment
  end

  def create
    respond_with(@comment = @parent.comments.create(comment_params))
  end

  def destroy
    respond_with (@comment.destroy)
  end

  private

  def publish_comment
    PrivatePub.publish_to "/#{@parent.class.to_s.pluralize.underscore}/#{@parent.id}/comments", comment: @comment.to_json
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def load_parent
    @parent = Question.find(params[:question_id]) if params[:question_id]
    @parent ||= Answer.find(params[:answer_id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end
end
