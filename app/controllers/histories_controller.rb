class HistoriesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]


  # GET /searches
  # GET /searches.json
  def index
    begin
      @search = Search.new
      @search.keywords = "Enter your keywords"
      @keywords = Search.all.order("keywords ASC").map { |s| s.keywords }
    rescue Exception => e
        logger.debug e.message
    else
    end
    respond_to do |format|
      format.js {}
    end
  end


end
