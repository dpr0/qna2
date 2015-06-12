require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user)      { create(:user) }
  let(:user2)     { create(:user) }
  let(:question)  { create(:question, user: user) }
  let(:answer)    { create(:answer, user: user, question: question) }
  let(:answer2)   { create(:answer, user: user2, question: question) }

  describe 'POST #create' do
    before { sign_in(user) }
    context 'with valid attributes' do
      it 'answer assigns to user and question' do
        post :create, user_id: user, question_id: question, answer: attributes_for(:answer)
        expect(answer.user_id).to eq user.id
        expect(answer.question_id).to eq question.id
      end
      it 'save associated answer' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end
      it 'redirects to Question_Show_View with id' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count)
      end
      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template 'questions/show'
      end
    end

  describe 'DELETE #destroy' do
# созданный ответ связывается с залогиненным пользователем?
# Пользователя из контроллера: subject.current_user
      #before { question }
      before { answer }
      it 'deletes answer' do
        sign_in(user)
        expect{ delete :destroy, id: answer.id }.to change(question.answers, :count).by(-1)
      end
      # Нужен тест на то, что пользователь не может удалить чужой ответ
      it 'user cant delete another user answer' do
        sign_in(user2)
        expect{ delete :destroy, id: answer.id }.to_not change(question.answers, :count)
      end
    end
  end
end

