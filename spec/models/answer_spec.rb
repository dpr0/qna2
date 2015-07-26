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
  it { should have_many(:votes).dependent(:destroy) }
  let!(:question) { create(:question) }
  let(:user) { create(:user ) }
  let(:user2) { create(:user ) }
  let(:user3) { create(:user ) }
  let(:user4) { create(:user ) }
  let(:answer) { create(:answer, question: question ) }
  
  describe 'votes' do
    it 'choose vote for question' do
      question.perfect(user)
      question.reload
      question.bullshit(user2)
      question.reload
      question.bullshit(user3)
      question.reload
      question.cancel(user3)
      question.perfect(user3)
      question.reload
      question.perfect(user4)
      question.reload
      expect(question.votes_count).to eq 2
    end

    it 'choose vote answer' do
      answer.perfect(user)
      answer.reload
      answer.bullshit(user2)
      answer.reload
      answer.bullshit(user3)
      answer.reload
      answer.cancel(user3)
      answer.perfect(user3)
      answer.reload
      answer.perfect(user4)
      answer.reload
      expect(answer.votes_count).to eq 2
    end
  end

  describe 'best answer' do
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
