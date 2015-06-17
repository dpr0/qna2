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
      before { post :create, question_id: question, answer: attributes_for(:answer), format: :js }
      it 'answer assigns to user and question' do
        expect(assigns(:answer).user_id).to eq subject.current_user.id
      end
      it 'save associated answer' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js  }.to change(question.answers, :count).by(1)
      end
      it 'render create template' do
        expect(response).to render_template :create
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
      # созданный ответ связывается с залогиненным пользователем?
      # Пользователя из контроллера: subject.current_user
      # before { question }
      before { answer }
      it 'deletes answer' do
        sign_in(user)
        expect { delete :destroy, id: answer.id }.to change(question.answers, :count).by(-1)
      end
      # Нужен тест на то, что пользователь не может удалить чужой ответ
      it 'user cant delete another user answer' do
        sign_in(user2)
        expect { delete :destroy, id: answer.id }.to_not change(question.answers, :count)
      end
    end
  end
end
