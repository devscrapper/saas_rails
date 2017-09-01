class ResultsController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  # GET /results
  # GET /results.json
  def index
    respond_to do |format|
      begin
        id = params[:id].to_i
        index = params[:index].to_i
        search_id =params[:search_id].to_i

        unless Result.exists?(:index => index + 3) # on controle que la page + 3 est déjà chargée
          # doit être égal au nombre de result fait la premiere fois dans search, sinon risque de trou si > ou reduction nombre prechargé
          Thread.new {
            count_pages = 1
            index_page = index + 3 # on controle que la page + 3 est déjà chargée
            # doit être égal au nombre de result fait la premiere fois dans search, sinon risque de trou si > ou reduction nombre prechargé

            @search = Search.find_by_id(search_id)
            @search.execute(index_page, count_pages)
          }
        else

        end
        @results = Result.where("id > #{id}").limit(10).order('id asc')

      rescue Exception => e
        logger.debug e.message
        format.js {}

      else
        format.js {}

      end
    end
  end

  # GET /results/1
  # GET /results/1.json

  def show
    @results = Result.find(params[:id])
    @search = @results.search

    if Result.find_by_id(@results.id.next.next.next) # on controle que la page + 3 est déjà chargée
      # doit être égal au nombre de result fait la premiere fois dans search, sinon risque de trou si > ou reduction nombre prechargé
      Thread.new {

        begin
          count_pages = 1
          index_page = @results.index + 3 # on controle que la page + 3 est déjà chargée
          # doit être égal au nombre de result fait la premiere fois dans search, sinon risque de trou si > ou reduction nombre prechargé

          @search.execute(index_page, count_pages)

        rescue Exception => e
          logger.debug e.message

        else
          format.js {}

        end
      }
    end
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

