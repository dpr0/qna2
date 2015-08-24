require 'rails_helper'

def do_request(options={})
  get api_way, {format: :json}.merge(options)
end
def do_request2
  perem1
  perem2
end

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable" do
      let(:api_way) {'/api/v1/profiles/me'}
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }
      it_behaves_like "API Authenticable 2" do
        let(:perem1) { me }
        let(:perem2) {""}
      end

      %w(email admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "doesnt contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  # --------------------------

  describe 'GET /users' do

    it_behaves_like "API Authenticable" do
      let(:api_way) {'/api/v1/profiles/'}
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 5) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/', format: :json, access_token: access_token.token }
      it_behaves_like "API Authenticable 2" do
        let(:perem1) { users[0] }
        let(:perem2) {"profiles/0/"}
      end

      it 'contains all users list' do
        expect(response.body).to be_json_eql(users.to_json).at_path("profiles")
      end
      %w(email admin).each do |attr|
        it "contains #{attr} all users" do
          users.each_with_index do |u, i|
            expect(response.body).to be_json_eql(u.send(attr.to_sym).to_json).at_path("profiles/#{i}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr} all users" do
          expect(response.body).to_not have_json_path("profiles/0/#{attr}")
        end
      end
    end
  end
end
