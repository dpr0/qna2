class Vote < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  belongs_to :votable, polymorphic: true
  validates :votable, presence: true # , inclusion: { in: ['Question', 'Answer'] }
  validates :score, presence: true, inclusion: { in: [-1, 1] }
end
