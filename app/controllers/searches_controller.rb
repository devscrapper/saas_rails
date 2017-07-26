class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  # GET /searches
  # GET /searches.json
  def index(results)
    #@searches = Search.all

  end

  # GET /searches/1
  # GET /searches/1.json
  def show
    results_count = JSON.parse(@search.results).count
    @notice =  "#{results_count} elements found."
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

          if @search.nil?

            results =RestClient.get "http://192.168.1.88:9251/?action=search&keywords=#{keywords}",
                                    :content_type => :json,
                                    :accept => :json
            # http://#{saas_host}:#{saas_port}/?action=search&keywords=#{keywords}&index=#{index}&count_pages=#{count_pages}")

            @search = Search.new(:keywords => keywords,
                                 :results => results.to_s.encode('UTF-8', {
                                   :invalid => :replace,
                                   :undef   => :replace,
                                   :replace => '?'
                                 }))
            @search.save!
          else

          end

          results_count = JSON.parse(@search.results).count
        rescue Exception => e

          format.html { render :new }
          format.json { render json: e.message, status: :unprocessable_entity }
        else

          format.html { redirect_to search_path(@search[:id] || @search.id), notice: "#{results_count} elements found." }
          format.json { render :show, status: :created, location: @search }
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
