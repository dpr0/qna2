class Answer < ActiveRecord::Base

  belongs_to :question
  belongs_to :user

  validates :body,         presence: true, length: { minimum: 2, maximum: 1000 }
  validates :question_id,  presence: true
  validates :user_id,  presence: true

  scope :firstbest, -> { order('best DESC') }
  def best_answer
    update_attributes(best: 1) # аттрибут не integer, он и есть boolean, а 1=true
  end
end
