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