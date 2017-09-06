class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  def delete_all
    Search.all.each { |s| s.delete }
  end

  # GET /searches
  # GET /searches.json
  def index(results)
    #@searches = Search.all

  end

  # GET /searches/1
  # GET /searches/1.json
  def show
    # results_count = @search.results.count
    # @notice = "#{results_count} elements found."
  end

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

            count_pages = 1
            index_page = 1
            @search.execute(index_page, count_pages)

            Thread.new {  # on pourrait utiliser 2 thread mais cela coute plus cher en ressource navigateur chez Saas
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

        rescue Exception => e
          logger.debug e.message
          format.html { render :new }
          format.json { render json: e.message, status: :unprocessable_entity }
        else
        #  format.json { render json: @result, status: :created }
        #  format.html { redirect_to results_path(:search_id => @search.id), notice: "" }
          format.js {}
          #  format.json { render :show, status: :created, location: @search }
        end
      end
    end
  end

  # PATCH/PUT /searches/1
  # PATCH/PUT /searches/1.json
  def update
    respond_to do |format|
      if @search.update(search_params)
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { render :show, status: :ok, location: @search }
      else
        format.html { render :edit }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url, notice: 'Search was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_search
    @search = Search.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def search_params
    params[:search]
  end
end
