class Question < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable
  include Reputationable

  has_many :answers, dependent: :destroy
  belongs_to :user

  after_create :update_reputation
  #after_create :calculate_reputation

  validates :title,   presence: true, length: { minimum: 5, maximum: 140 }
  validates :body,    presence: true, length: { minimum: 5, maximum: 1000 }
  validates :user_id, presence: true

end
