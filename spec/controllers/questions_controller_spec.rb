require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:question2) { create(:question, user: user2) }


  describe 'POST #perfect/bullshit/cancel' do
    sign_in_user

    it 'choose perfect question' do
      post :perfect, id: question, format: :js
      question.reload
      expect(question.votes_count).to eq 1
    end
    it 'choose bullshit question' do
      post :bullshit, id: question, format: :js
      question.reload
      expect(question.votes_count).to eq -1
    end
    it 'choose cancel question' do
      post :perfect, id: question, format: :js
      post :cancel, id: question, format: :js
      question.reload
      expect(question.votes_count).to eq 0
    end
    it 'Render question :perfect' do
      expect(post :perfect, id: question, format: :js).to render_template :perfect
    end
    it 'Render question :bullshit' do
      expect(post :bullshit, id: question, format: :js).to render_template :bullshit
    end
    it 'Render question :cancel' do
      post :perfect, id: question, format: :js
      expect(post :cancel, id: question, format: :js).to render_template :cancel
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }
    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before do
      question.update!(user: @user)
      get :edit, id: question
    end
    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    let(:create_question) { post :create, question: attributes_for(:question) }
    let(:create_invalid_question) { post :create, question: attributes_for(:invalid_question) }
    let(:path) { '/questions/new' }
    it_behaves_like "Publish_to question"
    
    context 'with valid attributes' do
      it 'question assigns to user' do
        post :create, question: attributes_for(:question)
        expect(assigns(:question).user_id).to eq subject.current_user.id
      end
      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    before do
      question.update!(user: @user)
    end
    context 'valid attributes' do
      it 'assings the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'redirects to the updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil } }
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end
      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:question1) { create(:question, user: subject.current_user) }
    it 'deletes question' do
      expect { delete :destroy, id: question1 }.to change(Question, :count).by(-1)
    end
    it 'redirect to index view' do
      delete :destroy, id: question1
      expect(response).to redirect_to questions_path
    end
    # Нужен тест на то, что пользователь не может удалить чужой вопрос
    it 'user cant delete another user question' do
      question2
      expect { delete :destroy, id: question2 }.to_not change(Question, :count)
    end
  end
end
