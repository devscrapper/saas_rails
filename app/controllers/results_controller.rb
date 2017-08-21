class ResultsController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  # GET /results
  # GET /results.json
  def index
    #@results = Result.where({:search_id => params[:search_id].}).page(params[:page] || 1)
    unless params[:search_id].nil?
    @results = Result.where(:search_id => params[:search_id]).paginate(:page => params[:page] || 1, :per_page => 10).order('id ASC') #car les results sont enregistre dans l'odre des poids, peu etre revisté plus tard
    else
      @results = Result.paginate(:page => params[:page] || 1, :per_page => 10).order('id ASC')
      end
    @search_id = params[:search_id]

  end

  # GET /results/1
  # GET /results/1.json
  def show
    @results = Result.find(params[:id])

    @next_results = Result.find_by_id(@results.id.next)

    Thread.new {
      begin
        engines = "google|yahoo|bing"
        count_pages = 1
        index_page = @results.index + 1
        keywords = @results.keywords
        href = "http://127.0.0.1:9251/?action=search&keywords=#{keywords}&engines=#{engines}&index_page=#{index_page}&count_pages=#{count_pages}"

        s = Time.now

        results =RestClient.get href,
                                :content_type => :json,
                                :accept => :json

        delay = Time.now - s

        results = JSON.parse(results).to_a.sort { |a, b| b[1]['weight'] <=> a[1]['weight'] }

        @result = @results.search.results.create!(:keywords => keywords,
                                                  :results => results,
                                                  :index => index_page,
                                                  :count_results => results.count,
                                                  :delay => delay)
      rescue Exception => e
        logger.debug e.message
      else
      end
    } if @next_results.nil?
  end

  # GET /results/new@result
  def new

  end

  # GET /results/1/edit
  def edit
  end

  # POST /results
  # POST /results.json
  def create

  end

  # PATCH/PUT /results/1
  # PATCH/PUT /results/1.json
  def update
    respond_to do |format|
      if @result.update(search_params)
        format.html { redirect_to @result, notice: 'Result was successfully updated.' }
        format.json { render :show, status: :ok, location: @result }
      else
        format.html { render :edit }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result.destroy
    respond_to do |format|
      format.html { redirect_to results_url, notice: 'Result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_result
    @result = Result.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def result_params
    params.require(:result).permit(:keywords, :results, :index, :search_id)
  end
end

