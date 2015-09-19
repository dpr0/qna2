require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  
  before { get :index, where_search: 'All', search_field: "Text" }
  it 'renders index view' do
    expect(response).to render_template :index
  end
end
