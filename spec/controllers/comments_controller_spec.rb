require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
		let(:user) { create(:user) }
		let(:question) { create(:question, user: user) }
		let(:answer) { create(:answer, user: user, question: question) }
	describe '#POST create' do
		sign_in_user
		it 'loads question if parent is question' do
			post :create, comment: attributes_for(:comment), question_id: question, format: :js
			expect(assigns(:parent)).to eq question
		end
		it 'loads answer if parent is answer' do
			post :create, comment: attributes_for(:comment), answer_id: answer, format: :js
			expect(assigns(:parent)).to eq answer
		end
	end

  describe 'PATCH #update' do
    sign_in_user
    it 'assings the requested answer to @answer' do
      post :update, comment: attributes_for(:comment), question_id: question, format: :js
      expect(assigns(:parent)).to eq answer
    end
    it 'assigns the question' do
      patch :update, comment: attributes_for(:comment), answer_id: answer, format: :js
      expect(assigns(:parent)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, comment: { body: 'new body' }, format: :js
      comment.reload
      expect(comment.body).to eq 'new body'
    end
    it 'render update template' do
      patch :update, comment: attributes_for(:comment), format: :js
      expect(response).to render_template :update
    end
  end


end
