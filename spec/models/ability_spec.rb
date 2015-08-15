require 'rails_helper'

describe Ability do
	subject(:ability) { Ability.new(user) }

	describe 'for guest' do
		let(:user) {nil}
		
		it { should be_able_to :read, Question }
		it { should be_able_to :read, Answer }
		it { should be_able_to :read, Comment }

		it { should_not be_able_to :manage, :all }		
	end

	describe 'for guest' do
		let(:user) { create :user, admin: 1 }
		
		it { should be_able_to :manage, :all }
	end

	describe 'for guest' do
		let(:user) { create :user }
		let(:user2) { create :user }
		let(:question1) { create(:question, user: user) }
		let(:question2) { create(:question, user: user2 ) }
		let(:answer1) { create(:answer, question: question1, user: user) }
		let(:answer2) { create(:answer, question: question1, user: user2 ) }
		let(:comment1) { create(:comment, commentable: question1, user: user) }
		let(:comment2) { create(:comment, commentable: question1, user: user2 ) }

		it { should_not be_able_to :manage, :all }
		it { should be_able_to :read, :all }

		it { should be_able_to :create, Question }
		it { should be_able_to :create, Answer }
		it { should be_able_to :create, Comment }
		
		it { should be_able_to :update, question1, user: user }
		it { should_not be_able_to :update, question2, user: user }

		it { should be_able_to :update, answer1, user: user }
		it { should_not be_able_to :update, answer2, user: user }

		it { should be_able_to :update, comment1, user: user }
		it { should_not be_able_to :update, comment2, user: user }
	end

end 