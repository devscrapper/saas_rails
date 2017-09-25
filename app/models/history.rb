class History < ActiveRecord::Base



  def self.all
     Search.history
  end
end
