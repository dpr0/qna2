class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body,         presence: true, length: { minimum: 2, maximum: 1000 }
  validates :question_id,  presence: true
end
