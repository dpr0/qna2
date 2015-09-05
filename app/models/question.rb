class Question < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable
  include Reputationable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  scope :lastday, -> { where(updated_at: Time.now - 1) }

  after_create :create_subscribe_for_author
  after_create :notify_the_subscriber
  after_create :update_reputation
  #after_create :calculate_reputation

  validates :title,   presence: true, length: { minimum: 5, maximum: 140 }
  validates :body,    presence: true, length: { minimum: 5, maximum: 1000 }
  validates :user_id, presence: true

  private

  def notify_the_subscriber
    AnswerNoticeJob.perform_later(self)
  end

  def create_subscribe_for_author
    Subscription.create(user: self.user, question: self)
  end
end
