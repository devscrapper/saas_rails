class CaptchasController < ApplicationController
  protect_from_forgery

  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :set_captcha, only: [:show, :edit, :destroy, :update]

  def create
    @captcha = Captcha.new

    respond_to do |format|
      begin
        @captcha.visitor_id = params['visitor_id']
        uploaded_io = params['image']
        @captcha.image_file_id = uploaded_io.original_filename
        # save to DB
        @captcha.save!

        # save image to /public
        File.open(Rails.root.join('public', 'images', uploaded_io.original_filename), 'wb') do |file|
          file.write(uploaded_io.read)
          file.close
        end

        # send mail
        CaptchaMailer.image_email(@captcha).deliver_now

      rescue Exception => e
        logger.debug e.message
        format.json { render json: e.message, status: :unprocessable_entity }

      else
        format.json { render json: @captcha, status: :created }
      end
    end
  end


  def edit

  end
    # GET /websites
  # GET /websites.json
  def index
    render json: Captcha.all
  end
  def show
    render json: @captcha
  end

  def update
    begin
      @captcha.update!(value: captcha_params["value"])

    rescue Exception => e
      respond_to do |format|
        format.html { render :edit }
      end
    else
      File.delete(Rails.root.join('public', 'images', @captcha.image_file_id))
      render json: @captcha, status: :created

    end

  end

  def destroy
    @captcha.destroy
    render json: :ok
  end

  protected

  def json_request?
    request.format.json?
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_captcha
    @captcha = Captcha.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def captcha_params
    params.require(:captcha).permit(:image,
                                    :visitor_id,
                                    :value)
  end
end
