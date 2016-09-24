=begin
<form
 method="post"
 action="http://poster.de-captcher.com/"
 enctype="multipart/form-data">
 <input type="hidden" name="function"  value="picture2">
 <input type="text"   name="username"  value="client">
 <input type="text"   name="password"  value="qwerty">
 <input type="file"   name="pict">
 <input type="text"   name="pict_type" value="0">
 <input type="submit" value="Send">
</form>
=end
=begin

D:\Personnel\referentiel\dev\statupbot\tmp>convert captcha_Chrome-39.0.2139.3_2016-06-30.png -crop 200x70+37+213 test.png
D:\Personnel\referentiel\dev\statupbot\tmp>convert *.png -crop 320x150+0+180 test*.png
=end

require 'rest-client'

captcha_file  = "out.png"
image = File.open(captcha_file)

resource = RestClient::Resource.new("http://poster.de-captcher.com")
response = resource.post("function" => "picture2",
                         "username" => "lesclesdumidi",
                         "password" => "lesclesdumidi34",
                         "pict" => image,
                         "pict_type" => "0",
                         "submit" => "Send")
nul, major_id, minor_id, nul, nul, captcha_text = response.split("|")
p response
p  major_id
p minor_id
p captcha_text

 #extraction captcha
        captcha_file = Flow.new(TMP, "captcha", id_visitor, Date.today, nil, ".png")
        MiniMagick.cli = :imagemagick
        MiniMagick.cli_path = $mini_magic_path
        MiniMagick.debug = true  if $debugging
        MiniMagick::Tool::Convert.new do |builder|
          builder << screenshot_file.absolute_path
          builder.crop $cropping_size
          builder << captcha_file.absolute_path
        end
        @@logger.an_event.debug "captcha extracted"