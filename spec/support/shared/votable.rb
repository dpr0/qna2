shared_examples_for "votable" do
  context 'votes' do
    it 'choose perfect vote for votable' do
      votable.perfect(user)
      votable.reload
      expect(votable.votes_count).to eq 1
    end
    it 'choose bullshit vote for votable' do
      votable.bullshit(user)
      votable.reload
      expect(votable.votes_count).to eq -1
    end
    it 'cancel vote for votable' do
      votable.perfect(user)
      votable.reload
      votable.cancel(user)
      expect(votable.votes_count).to eq 0
    end
  end
end