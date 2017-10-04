require "mail_sender"

class SharesController < ApplicationController
  before_action :set_share, only: [:show, :edit, :update, :destroy]

  # GET /shares
  # GET /shares.json
  def index
    @shares = Share.all
  end

  # GET /shares/1
  # GET /shares/1.json
  def show
  end

  # GET /shares/new
  def new
    @share = Share.new
    @search = Search.new
    respond_to do |format|
      format.js {}
    end
  end

  # GET /shares/1/edit
  def edit
  end

  # POST /shares
  # POST /shares.json
  def create
    logger.debug "keywords #{cookies['keywords']}"
    logger.debug "share #{cookies['share']}"

    respond_to do |format|
      begin
        keywords = cookies['keywords']
        tool = cookies['tool']
        recipient = share_params["recipient"]
        case tool
          when "mail"

            text = "A friend desire to share a web search with you #{url_for("http://olgadays.synology.me:8081/searches/#{keywords}")}" #TODO a variabiliser
            logger.debug "text mail #{text}"
            logger.debug "recipient #{recipient}"
            MailSender.new("search.com", recipient, "share a search", text).send

        end
        @search = Search.find_by_keywords(keywords)
        logger.debug "count results for search #{keywords} #{@search.results.size}"

      rescue Exception => e
        logger.debug e.message
      else

      ensure
         format.js {}


      end
    end
  end

  # PATCH/PUT /shares/1
  # PATCH/PUT /shares/1.json
  def update
    respond_to do |format|
      if @share.update(share_params)
        format.html { redirect_to @share, notice: 'Share was successfully updated.' }
        format.json { render :show, status: :ok, location: @share }
      else
        format.html { render :edit }
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shares/1
  # DELETE /shares/1.json
  def destroy
    @share.destroy
    respond_to do |format|
      format.html { redirect_to shares_url, notice: 'Share was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_share
    @share = Share.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def share_params
    params[:share]
  end
end
