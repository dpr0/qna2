require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attaches).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should validate_length_of(:title).is_at_most(140) }
  it { should validate_length_of(:body).is_at_most(1000) }
  it { should accept_nested_attributes_for :attaches }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  let(:question) { create(:question) }
  let(:user) { create(:user ) }

  describe 'votes' do
    it 'choose perfect vote for question' do
      question.perfect(user)
      question.reload
      expect(question.votes_count).to eq 1
    end
    it 'choose bullshit vote for question' do
      question.bullshit(user)
      question.reload
      expect(question.votes_count).to eq -1
    end
    it 'cancel vote for question' do
      question.perfect(user)
      question.reload
      question.cancel(user)
      expect(question.votes_count).to eq 0
    end
  end
end
