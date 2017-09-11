class Result < ActiveRecord::Base
  belongs_to :search
  serialize :results, Array


  def self.favicon(domain)
    begin
      require 'open-uri'
      open(Rails.root.join('public', 'images', domain + ".png"), 'wb') do |file|
        file << open("http://www.google.com/s2/favicons?domain=#{domain}").read
      end unless File.exist?(Rails.root.join('public', 'images', domain + ".png"))
    rescue Exception => e
    end

    domain + ".png"
  end


end
