class User < ActiveRecord::Base
  has_many :questions
  has_many :answers

  validates :login, presence: true, length: { minimum: 2, maximum: 30 }
end
