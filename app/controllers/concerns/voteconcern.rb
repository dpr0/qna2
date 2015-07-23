require 'active_support/concern'

module Voteconcern
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:perfect, :bullshit, :cancel]
  end

  def perfect
    @votable.perfect(current_user.id)
  end

  def bullshit
    @votable.bullshit(current_user.id)
  end

  def cancel
    @votable.cancel(current_user.id)
  end

  private

  def load_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end
