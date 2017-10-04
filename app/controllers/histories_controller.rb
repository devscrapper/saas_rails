class HistoriesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]


  # GET /searches
  # GET /searches.json
  def index
    begin

      unless cookies['history'].nil? # à remplacer par le controleque le user n'est pas identifié. Car si il l'est alors on lui retourne son hisotrique savegardé
        @history = cookies['history'].split("||").map { |k|
          unless k.empty?
            arr = k.split("|")
            {keywords: arr[0], date: Time.at(arr[2][0..9].to_i)} #on enleve les milliemes (3derniers chiffre à droite)
          end
        }.compact!
      else
        @history = History.all

      end

      unless cookies['favorites'].nil? # à remplacer par le controleque le user n'est pas identifié. Car si il l'est alors on lui retourne son hisotrique savegardé
        @favorites = cookies['favorites'].split("||").map { |k|
          unless k.empty?
            arr = k.split("|")
            {keywords: arr[0], date: Time.at(arr[2][0..9].to_i)} #on enleve les milliemes (3derniers chiffre à droite)
          end
        }.compact!
      else
        #TODO @searches = Favorite.all
        @favorites = []
      end

      @search = Search.new

    rescue Exception => e
      logger.debug e.message

    else
      respond_to do |format|
        format.js {}

      end
    end

  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy

    @searches = History.all
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
