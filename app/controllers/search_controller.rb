class SearchController < ApplicationController
  def index
    @results = ThinkingSphinx.search(params[:q])
  end
end
