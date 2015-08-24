shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it "api_path" do
      do_request
      expect(response.status).to eq 401
    end
    it "return 401 status if non valid access token" do
      do_request(access_token: '1234')
      expect(response.status).to eq 401
    end
  end
end