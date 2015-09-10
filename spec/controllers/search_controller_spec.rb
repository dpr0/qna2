require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  
  before { get :index, where_search: 'All' }
  it 'renders index view' do
    expect(response).to render_template :index
  end
end
