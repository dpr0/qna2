class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :attaches, as: :attachable, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :attaches

  validates :body,        presence: true, length: { minimum: 2, maximum: 1000 }
  validates :question_id, presence: true
  validates :user_id,     presence: true

  scope :firstbest, -> { order('best DESC') }

  def best_answer
    $oldbest = question.answers.find_by(best: true)
    $oldbest.update_attributes(best: false) if $oldbest
    update_attributes(best: true)
    # инстансная переменная @oldanswer - не передается во вьюху
    # поэтому пока глобальная. как найду решение - обязательно уберу
  end
end
