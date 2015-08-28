shared_examples_for "API Authenticable 2" do
  context 'authorized' do
    it 'return status 200' do
      expect(response).to be_success
    end
    %w(id created_at updated_at).each do |attr|
      it "contains #{attr}" do
        do_request2
        expect(response.body).to be_json_eql(perem1.send(attr.to_sym).to_json).at_path(perem2 + attr)
      end
    end
  end
end