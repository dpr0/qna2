class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attaches, dependent: :destroy
  belongs_to :user

  validates :title,   presence: true, length: { minimum: 5, maximum: 140 }
  validates :body,    presence: true, length: { minimum: 5, maximum: 1000 }
  validates :user_id,  presence: true

  accepts_nested_attributes_for :attaches
end
