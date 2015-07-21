require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attaches).dependent(:destroy) }
  it { should accept_nested_attributes_for :attaches }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_length_of(:body).is_at_most(1000) }

  describe 'best answer' do
    let!(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, best: false) }
    let(:answer2) { create(:answer, question: question, best: false) }

    it 'choose best answer' do
      answer.best_answer
      expect(answer.best).to eq true
    end

    it 'previous best answer is not best' do
      create(:answer, question: question, best: true)
      answer.best_answer
      answer2.best_answer
      answer.reload
      expect(answer2.best).to eq true
      expect(answer.best).to eq false
    end
  end
end
