class AttachesController < ApplicationController
  before_action :authenticate_user!
  def destroy
    @attach = Attach.find(params[:id])
    if @attach.attachable_type == 'Question'
      temp = Question.find(@attach.attachable_id)
    else
      temp = Answer.find(@attach.attachable_id)
    end
    @attach.destroy if current_user.id == temp.user_id
  end
end
