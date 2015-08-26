require 'rails_helper'

RSpec.describe Question, type: :model do

  subject { build(:question) }

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

  describe "Reputation" do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it "validate presence of title" do
      expect(subject.title).to_not be_nil
      expect(subject.title).to eq "MyString"
    end

    it "should calculate reputation after create" do
      expect(Reputation).to receive(:calculate).with(subject)
      subject.save!
    end

    it "should not calculate reputation after update" do
      subject.save!
      expect(Reputation).to_not receive(:calculate)
      subject.update(title: '123')
    end

    it "should save user reputation" do
      allow(Reputation).to receive(:calculate).and_return(5)
      expect { subject.save! }.to change(user, :reputation).by(5)
    end
  end

  let(:votable) { create(:question) }
  let(:user) { create(:user) }
  it_behaves_like "votable"

end