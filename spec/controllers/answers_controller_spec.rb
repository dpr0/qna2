require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user)      { create(:user) }
  let(:user2)     { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer)    { create(:answer, user: user, question: question) }
  let(:answer2)   { create(:answer, user: user2, question: question) }

  describe 'POST #perfect/bullshit/cancel' do
    sign_in_user

    it 'choose perfect answer' do
      post :perfect, id: answer, format: :js
      answer.reload
      expect(answer.votes_count).to eq 1
    end
    it 'choose bullshit answer' do
      post :bullshit, id: answer, format: :js
      answer.reload
      expect(answer.votes_count).to eq -1
    end
    it 'choose perfect answer' do
      post :perfect, id: answer, format: :js
      post :cancel, id: answer, format: :js
      answer.reload
      expect(answer.votes_count).to eq 0
    end

    it 'Render answer :perfect' do
      expect(post :perfect, id: answer, format: :js).to render_template :perfect
    end
    it 'Render answer :bullshit' do
      expect(post :bullshit, id: answer, format: :js).to render_template :bullshit
    end
    it 'Render answer :cancel' do
      post :perfect, id: answer, format: :js
      expect(post :cancel, id:   answer, format: :js).to render_template :cancel
    end
  end

  describe 'best answer' do
    sign_in_user
    before do
      question.update! user: @user
      post :best, id: answer, question_id: question, format: :js
    end
    it 'choose best answer' do
      answer.reload
      expect(answer.best).to eq true
    end

    it 'Render answer :best' do
      expect(response).to render_template :best
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    before do
      answer.update! user: @user
    end

    it 'assings the requested answer to @answer' do
      patch :update, id: answer, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end
    it 'assigns the question' do
      patch :update, id: answer, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, id: answer, answer: { body: 'new body' }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end
    it 'render update template' do
      patch :update, id: answer, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }
    context 'with valid attributes' do
      before { post :create, question_id: question, answer: attributes_for(:answer), format: :js }
      it 'answer assigns to user and question' do
        expect(assigns(:answer).user_id).to eq subject.current_user.id
      end
      it 'save associated answer' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end
      it 'render create template' do
        # expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end

    describe 'DELETE #destroy' do
      before { answer }
      it 'deletes answer' do
        sign_in(user)
        expect { delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end
      it 'user cant delete another user answer' do
        sign_in(user2)
        expect { delete :destroy, id: answer.id, format: :js }.to_not change(question.answers, :count)
      end
    end
  end
end
