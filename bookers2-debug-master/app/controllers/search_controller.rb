class SearchController < ApplicationController
  before_action :authenticate_user!
  def search
    @word = params[:word]
    @model = params[:model]
    @how_to = params[:how_to]

    if @model == 'user'
      @results = User.search_record(@word, @how_to)
    else
      @results = Book.search_record(@word, @how_to)
    end
  end
end
