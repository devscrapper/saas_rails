class HistoriesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]



  # GET /searches
  # GET /searches.json
  def index
    begin
      @search = Search.new
      @search.keywords = "Enter your keywords"
      @searches = Search.all.order("keywords ASC")
    rescue Exception => e
        logger.debug e.message
    else
    end
    respond_to do |format|
      format.js {}
    end
  end
    # Use callbacks to share common setup or constraints between actions.
  def set_search
    begin
      #recherche id d'une occurence
      @search = Search.find(params[:id])
    rescue Exception => e
      #recherche avec un mot clé (pour show)
      @search = Search.find_by_keywords(params[:id])
    else
    end
  end
     # Never trust parameters from the scary internet, only allow the white list through.
  def search_params
    params[:search]
  end

end
