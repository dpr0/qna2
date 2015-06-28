class Answer < ActiveRecord::Base

  belongs_to :question
  belongs_to :user

  validates :body,         presence: true, length: { minimum: 2, maximum: 1000 }
  validates :question_id,  presence: true
  validates :user_id,  presence: true

  scope :firstbest, -> { order('best DESC') }
  def best_answer
    #@oldbest = $answer.question.answers.find_by(best: 1)
    #@oldbest.update_attributes(best: 0)
    #$answer.update_attributes(best: 1)
  end
end
