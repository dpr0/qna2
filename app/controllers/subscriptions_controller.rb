class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_subscription, only: :destroy
  respond_to :js
  authorize_resource

  def index
    @subscriptions = Subscription.all
  end

  def create
    @question = Question.find(params[:question_id])
    #respond_with(@subscription = Subscription.create(question: @question, user: current_user))
    respond_with(@subscription = current_user.subscriptions.create(question: @question))
  end

  def destroy
    #@subscription = Subscription.where(user: current_user, question: @question).first
    respond_with (@subscription.destroy)
    #respond_with(@subscription = current_user.subscriptions.destroy(question: @question))
  end

  private

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end
end
