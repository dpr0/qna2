require 'active_support/concern'

module Reputationable
  extend ActiveSupport::Concern

  private

  def update_reputation
    #self.delay.calculate_reputation
    CalculateReputationJob.perform_later(self)
  end

#  def calculate_reputation
#    Reputation.delay.calculate(self)
#    #reputation = Reputation.delay.calculate(self)
#    #self.user.update(reputation: reputation)
#  end
end