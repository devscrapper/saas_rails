require 'rest-client'


class CaptchasController < ApplicationController
  protect_from_forgery

  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :set_captcha, only: [:show, :edit, :destroy, :update]

  def create
    @captcha = Captcha.new

    respond_to do |format|
      begin
        @captcha.visit_id = params['visit_id']
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
        case params['mode']
          when 'auto'
            #send to decaptcher
            decaptcher_user= parameters.decaptcher_user
            decaptcher_password= parameters.decaptcher_password

            logger.debug "decaptcher_user #{decaptcher_user}"
            logger.debug "decaptcher_password #{decaptcher_password}"

            image = File.open(Rails.root.join('public', 'images', uploaded_io.original_filename))

            resource = RestClient::Resource.new("http://poster.de-captcher.com")
            response = resource.post("function" => "picture2",
                                     "username" => decaptcher_user,
                                     "password" => decaptcher_password,
                                     "pict" => image,
                                     "pict_type" => "0",
                                     "submit" => "Send")
            #TODO tester les CR de de captcher?
            #TODO comment identifier qu'un problème est survenue ?
            #on ne supprime pas les image si il y a des erreurs pour confirmer qu'il ya eu des erreurs.

            logger.debug response

            nul, major_id, minor_id, nul, nul, value = response.split("|")

            logger.debug "major_id #{major_id}"
            logger.debug "minor_id #{minor_id}"
            logger.debug "text captcha #{value}"

            @captcha.update!({:major_id => major_id,
                              :minor_id => minor_id,
                              :value => value}) # major_id, minr_id sont utilis� par decaptcher pour identifier le capctha

            File.delete(Rails.root.join('public', 'images', @captcha.image_file_id))

          when 'manual'
            # send mail
            hostname_public = parameters.hostname_public
            to = parameters.to

            logger.debug "hostname_public #{hostname_public}"
            logger.debug "to #{to}"

            CaptchaMailer.image_email(@captcha.id, hostname_public, to).deliver_now

          else
            raise "unknown mode #{params['mode']}"
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
                                    :visit_id,
                                    :value)
  end
end
