class SearchController < ApplicationController
  authorize_resource class: User

  def index
    @result = Search.search(params[:search_field], params[:where_search])
    respond_with @result
  end
end
