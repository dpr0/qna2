require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_length_of(:body).is_at_most(1000) }

  describe 'best answer' do

    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }

    it 'choose best answer' do
      pending("something else getting finished")
      answer.best_answer
      expect(answer.best).to eq true
    end
    it 'previous best answer is not best' do
      pending("something else getting finished")
      answer2.best_answer
      expect(answer2.best).to eq true
      expect(answer.best).to eq false
    end

  end

end
