shared_examples_for 'Commentable' do
  it 'increases comments count' do
    expect { request }.to change(get_commentable.comments, :count).by(1)
  end

  it 'receives 200 status code' do
    request
    expect(response).to have_http_status(200)
  end
end