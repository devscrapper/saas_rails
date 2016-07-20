class CaptchaMailer < ApplicationMailer

  default from: 'notifications@example.com'

  def image_email(captcha_id,  hostname_public, to)
    @url = url_for(host: hostname_public, action: 'edit', controller: 'captchas', id: captcha_id, only_path: false, protocol: 'http')
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
