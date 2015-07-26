require 'active_support/concern'

module Votemodelconcern
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def perfect(user)
    increment!(:votes_count)
    votes << Vote.new(user_id: user, score: 1)
  end

  def bullshit(user)
    decrement!(:votes_count)
    votes << Vote.new(user_id: user, score: -1)
  end

  def cancel(user)
    vote = votes.find_by(user_id: user)
    if vote.score == 1
      decrement!(:votes_count)
    else
      increment!(:votes_count)
    end
    vote.destroy if vote.user_id == user
  end
end
