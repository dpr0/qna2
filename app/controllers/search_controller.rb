class SearchController < ApplicationController
  authorize_resource

  def index
    search = search_params[:where_search]
    if search =='All'
      @result = ThinkingSphinx.search search_params[:search_field]
    else
      @result = ThinkingSphinx.search search_params[:search_field]
      @result = search.singularize.classify.constantize.search search_params[:search_field] if search
    end
  end

  def search_params
    params.permit(:where_search, :search_field, :commit)
  end
end
