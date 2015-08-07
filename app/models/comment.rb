class Comment < ActiveRecord::Base

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { minimum: 2, maximum: 1000 }
  validates :user, presence: true
  validates :commentable, presence: true

end
