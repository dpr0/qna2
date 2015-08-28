class Question < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title,   presence: true, length: { minimum: 5, maximum: 140 }
  validates :body,    presence: true, length: { minimum: 5, maximum: 1000 }
  validates :user_id, presence: true

  after_create :calculate_reputation

  private

  def calculate_reputation
    reputation = Reputation.calculate(self)
    self.user.update(reputation: reputation)
  end
end
