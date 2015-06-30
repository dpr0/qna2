class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attaches, as: :attachable
  belongs_to :user
  accepts_nested_attributes_for :attaches

  validates :title,   presence: true, length: { minimum: 5, maximum: 140 }
  validates :body,    presence: true, length: { minimum: 5, maximum: 1000 }
  validates :user_id,  presence: true

end
