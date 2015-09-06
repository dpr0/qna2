require 'rails_helper'

RSpec.describe Question, type: :model do

  subject { build(:question) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attaches).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should validate_length_of(:title).is_at_most(140) }
  it { should validate_length_of(:body).is_at_most(1000) }
  it { should accept_nested_attributes_for :attaches }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  describe "reputation" do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it_behaves_like 'calculates reputation'

    
#    it "should save user reputation" do
#      allow(Reputation).to receive(:calculate).and_return(5)
#      expect { subject.save! }.to change(user, :reputation).by(5)
#    end
#  
#    it 'test time' do
#      now = Time.now.utc
#      allow(Time).to receive(:now) { now }
#      subject.save!
#      expect(subject.created_at).to eq now
#    end
  end

#  it 'test double' do
#    question = double(Question, title: '123')
#    allow(Question).to receive(:find) { question }
#    expect(Question.find(1).title).to eq '123'
#  end

  let(:votable) { create(:question) }
  let(:user) { create(:user) }
  it_behaves_like "votable"

end