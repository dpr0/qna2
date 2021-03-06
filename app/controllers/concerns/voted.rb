require 'active_support/concern'

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:perfect, :bullshit, :cancel]
  end

  def perfect
    # authorize! :perfect, @votable
    @votable.perfect(current_user)
  end

  def bullshit
    # authorize! :bullshit, @votable
    @votable.bullshit(current_user)
  end

  def cancel
    # authorize! :cancel, @votable
    @votable.cancel(current_user)
  end

  private

  def load_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end
