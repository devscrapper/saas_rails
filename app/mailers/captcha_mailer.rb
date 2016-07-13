class CaptchaMailer < ApplicationMailer

  default from: 'notifications@example.com'

  def image_email(captcha)
    @visitor_id = captcha.visitor_id

    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      hostname_public = parameters.hostname_public
      to = parameters.to
    end


    @url = url_for(host: hostname_public, action: 'edit', controller: 'captchas', id: captcha.id, only_path: false, protocol: 'http')
    logger.debug "url captcha form #{@url}"

    begin
      mail(to: to, subject: "#{ENV['RACK_ENV']} - input")

    rescue Exception => e
      logger.debug e.message

    else
      logger.debug "mail sent to #{to}"
    end
  end

end
