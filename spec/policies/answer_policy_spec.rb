require 'rails_helper'

describe AnswerPolicy do

  let(:user) { create :user }

  subject { described_class }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: 1), create(:answer))
    end
    
    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it 'danies access if user isnt author' do
      expect(subject).to_not permit(User.new, create(:answer, user: user))
    end
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
