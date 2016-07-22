require 'rest-client'


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

        parameters = Parameter.new("captcha")
        hostname_public = parameters.hostname_public
        to = parameters.to
        decaptcher_user=   parameters.decaptcher_user
        decaptcher_password=   parameters.decaptcher_password

        #send to decaptcher
        begin
          image = File.open(Rails.root.join('public', 'images', uploaded_io.original_filename))

          resource = RestClient::Resource.new("http://poster.de-captcher.com")
          response = resource.post("function" => "picture2",
                                   "username" => decaptcher_user,
                                   "password" => decaptcher_password,
                                   "pict" => image,
                                   "pict_type" => "0",
                                   "submit" => "Send")

          logger.debug response
          nul, major_id, minor_id, nul, nul, value = response.split("|")

          logger.debug "major_id #{major_id}"
          logger.debug "minor_id #{minor_id}"
          logger.debug "text captcha#{value}"

          @captcha.update!(major_id: major_id)   # major_id, minr_id sont utilisé par decaptcher pour identifier le capctha
          @captcha.update!(minor_id: minor_id)
          @captcha.update!(value: value)

        rescue Exception => e
          logger.debug e.message

          # send mail
          CaptchaMailer.image_email(@captcha.id, hostname_public, to).deliver_now

        else

        end

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
