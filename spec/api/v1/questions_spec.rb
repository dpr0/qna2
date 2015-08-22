require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }
  let!(:questions) { create_list(:question, 2) }
  let(:question) { questions.first }

  describe 'GET /index' do
    let!(:answer) { create(:answer, question: question) }
    context 'unauthorized' do
      it 'return status 401 if there is no access token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'return status 401 if access token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get '/api/v1/questions', format: :json, access_token: access_token.token }
      
      it 'return status 200' do
        expect(response).to be_success
      end

      it 'return list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end

      end

    end
  end

  describe 'GET /questions/:id' do
    let!(:answers) { create_list(:answer, 2) }
    let!(:attaches) { create_list(:attach, 2, attachable_id: question, attachable_type: 'Question') }

    context 'unauthorized' do
      it "return 401 status if no access token" do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end
      it "return 401 status if non valid access token" do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'contains question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        let!(:comments) { create_list(:comment, 2, commentable: question, commentable_type: 'Question') }
        it 'contains comments in question' do
          expect(response.body).to have_json_size(2).at_path('question/comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "comment contains #{attr}" do
            expect(response.body).to be_json_eql(comments[1].send(attr.to_sym).to_json).at_path("question/comments/1/#{attr}")
          end
        end
      end

      context 'attaches' do
        it 'contains attaches in question' do
          expect(response.body).to have_json_size(2).at_path('question/attaches')
        end

        it "attach contains file" do
          expect(response.body).to be_json_eql(attaches[1].file.url.to_json).at_path("question/attaches/0/url")
        end
      end
    end
  end

  describe 'POST /questions' do
    context 'valid attributes' do
      before { post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token }
      #before { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token }
      it 'returns status 201' do
        expect(response).to have_http_status :created
      end

      it 'create' do
        expect(response).to change(Question, :count).by(1)
      end
    end 

    context 'invalid attributes' do
      before { post '/api/v1/questions', question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }
      
      it 'returns status 422' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'not create' do
        expect(response).to_not change(Question, :count)
      end
    end
  end

end