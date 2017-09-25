class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  def delete_all
    Search.all.each { |s| s.delete }
  end

  # GET /searches
  # GET /searches.json
  def index
    #@searches = Search.all

  end

  # GET /searches/1
  # GET /searches/1.json

  # GET /searches/new@search
  def new
    @search = Search.new
    @search.keywords = "Enter your keywords"
  end

  # GET /searches/1/edit
  def edit
  end

  # POST /searches
  # POST /searches.json
  def create
    respond_to do |format|
      unless search_params['keywords'].nil?
        begin
          keywords = search_params['keywords']

          @search = Search.find_by_keywords(keywords)
          # option utiulisateur : vitesse ou compl�tude tri�e => count_page petit ou cout_page grand
          if @search.nil?
            @search = Search.new(:keywords => keywords) #
            @search.save!
          end
          if @search.results.empty?
            count_pages = 1
            index_page = 1
            @search.execute(index_page, count_pages)

            Thread.new {# on pourrait utiliser 2 thread mais cela coute plus cher en ressource navigateur chez Saas
              count_pages = 1
              index_page = 2
              @search.execute(index_page, count_pages)
              # on pourrait aussi faire une recherche avec count_page = 2 pour eviter 2 appel ; la difference =
              # les pages serait rangé sur le même index = 2, les liens serait classé en mélangeant des pages ; est ce un pb ?
              index_page = 3
              @search.execute(index_page, count_pages)
            }
          else

          end
          @share = Search.new
        rescue Exception => e
          logger.debug e.message
          format.html { render :new }
          format.json { render json: e.message, status: :unprocessable_entity }
          format.js {}
        else
          #  format.json { render json: @result, status: :created }
          #  format.html { redirect_to results_path(:search_id => @search.id), notice: "" }
          format.js {}
          #  format.json { render :show, status: :created, location: @search }
        end
      end
    end
  end


  def show
    logger.debug params
    respond_to do |format|
      format.js {}
    end
  end


  # PATCH/PUT /searches/1
  # PATCH/PUT /searches/1.json
  def update

    @search.results.each { |result| @search.results.destroy(result) }

    begin
      count_pages = 1
      index_page = 1
      @search.execute(index_page, count_pages)

      Thread.new {# on pourrait utiliser 2 thread mais cela coute plus cher en ressource navigateur chez Saas
        count_pages = 1
        index_page = 2
        @search.execute(index_page, count_pages)
        # on pourrait aussi faire une recherche avec count_page = 2 pour eviter 2 appel ; la difference =
        # les pages serait rangé sur le même index = 2, les liens serait classé en mélangeant des pages ; est ce un pb ?
        index_page = 3
        @search.execute(index_page, count_pages)
      }
    rescue Exception => e
      logger.debug e.message
    else
    ensure
      respond_to do |format|
        format.js {}
      end
    end
  end


  private
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
