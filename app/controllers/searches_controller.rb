class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  def delete_all
    Search.all.each{|s| s.delete}
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
  end

  # GET /searches/1/edit
  def edit
  end

  # POST /searches
  # POST /searches.json
  def create
    respond_to do |format|
      unless params['keywords'].nil?
        begin

          keywords = params['keywords'][0]

          @search = Search.find_by_keywords(keywords)
          # option utiulisateur : vitesse ou compl�tude tri�e => count_page petit ou cout_page grand
          if @search.nil?
            engines = "google|yahoo|bing"
            count_pages = 1
            index_page = 1
            href = "http://127.0.0.1:9251/?action=search&keywords=#{keywords}&engines=#{engines}&index_page=#{index_page}&count_pages=#{count_pages}"

            logger.debug href
            s = Time.now

            results =RestClient.get href,
                                    :content_type => :json,
                                    :accept => :json

            delay = Time.now - s
            @search = Search.new(:keywords => keywords) #
            @search.save!

            results = JSON.parse(results).to_a.sort { |a, b| b[1]['weight'] <=> a[1]['weight'] }

            while !(ten_results = results.shift(1)).empty?
              @result = @search.results.create!(:keywords => keywords,
                                                :results => ten_results,
                                                :index => index_page,
                                                :count_results => ten_results.count,
                                                :delay => delay)
            end

            Thread.new {
              engines = "google|yahoo|bing"
              count_pages = 1
              index_page = 2
              href = "http://127.0.0.1:9251/?action=search&keywords=#{keywords}&engines=#{engines}&index_page=#{index_page}&count_pages=#{count_pages}"
              logger.debug href
              s = Time.now

              results =RestClient.get href,
                                      :content_type => :json,
                                      :accept => :json

              delay = Time.now - s

              results = JSON.parse(results).to_a.sort { |a, b| b[1]['weight'] <=> a[1]['weight'] }
              while !(ten_results = results.shift(10)).empty?
                @result = @search.results.create!(:keywords => keywords,
                                                  :results => ten_results,
                                                  :index => index_page,
                                                  :count_results => ten_results.count,
                                                  :delay => delay)
              end
            }
          else

          end

        rescue Exception => e
          logger.debug e.message
          format.html { render :new }
          format.json { render json: e.message, status: :unprocessable_entity }
        else
          format.json   {  render json: @result, status: :created}
          format.html { redirect_to results_path(:search_id => @search.id), notice: "" }
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
