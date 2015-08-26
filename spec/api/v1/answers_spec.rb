require 'rails_helper'

def do_request(options={})
  get api_way, {format: :json}.merge(options)
end

describe 'Answer API' do
  let!(:user) { create(:user) }
  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:question) { create(:question) }

  describe 'GET /answers' do
    it_behaves_like "API Authenticable" do
      let(:api_way) {"/api/v1/questions/#{question.id}/answers"}
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token}
      let(:perem1) { answers[0] }
      let(:perem2) {"answers/0/"}
      it_behaves_like "API Authenticable 2"

      it 'contains answers list' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(body).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answers[0].send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /questions/:id/answers/:id' do
    let(:answer) { create(:answer, question: question) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let!(:attaches) { create_list(:attach, 2, attachable: answer) }

    it_behaves_like "API Authenticable" do
      let(:api_way) {"/api/v1/questions/#{question.id}/answers/#{answer.id}"}
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }
      let(:perem1) { answer }
      let(:perem2) {"answer/"}
      it_behaves_like "API Authenticable 2"
        
      it 'contains answer' do
        expect(response.body).to have_json_size(1)
      end

      it "answer contains body" do
        expect(response.body).to be_json_eql(answer.send("body".to_sym).to_json).at_path("answer/body")
      end

      context 'comments' do
        it 'contains comments in answer' do
          expect(response.body).to have_json_size(2).at_path('answer/comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "comment contains #{attr}" do
            expect(response.body).to be_json_eql(comments[1].send(attr.to_sym).to_json).at_path("answer/comments/1/#{attr}")
          end
        end
      end

      context 'attaches' do
        it 'contains attaches in answer' do
          expect(response.body).to have_json_size(2).at_path('answer/attaches')
        end

        it "attach contains file" do
          expect(response.body).to be_json_eql(attaches[1].file.url.to_json).at_path("answer/attaches/0/url")
        end
      end
    end
  end
  
  describe 'POST /answers' do
    context 'valid attributes' do
      before { post "/api/v1/questions/#{question.id}/answers", question: question, answer: attributes_for(:answer), format: :json, access_token: access_token.token }
      it 'create' do
        expect { post "/api/v1/questions/#{question.id}/answers", format: :json, answer: attributes_for(:answer), access_token: access_token.token }.to change(Answer, :count).by(1)
      end
      it 'returns status 201' do
        expect(response.status).to eq 201
        expect(response).to have_http_status :created
      end
    end 

    context 'invalid attributes' do
      before { post "/api/v1/questions/#{question.id}/answers", question: question, answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }
      it 'returns status 422' do
        expect(response.status).to eq 422
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'not create' do
        expect  { post "/api/v1/questions/#{question.id}/answers", format: :json, answer: attributes_for(:invalid_answer), access_token: access_token.token }.to_not change(Answer, :count)
      end
    end
  end
end