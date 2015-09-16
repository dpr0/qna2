require 'rails_helper'

RSpec.describe Search, type: :model do
  let(:required) { 'Text' }
  let(:where)    { 'Question' }

  describe 'search' do
    it 'required nil?' do
      #expect(Search.search(nil)).to be_nil
    end

    it 'search if (where) = All' do
      expect(ThinkingSphinx).to receive(:search).with(required)
      Search.search(required)
    end

    it 'search if (where) = Q or A or C' do
      expect(ThinkingSphinx).to receive(:search).with(required, classes: [where.constantize])
      Search.search(required, where)
    end

  end
end
