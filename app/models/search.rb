class Search < ActiveRecord::Base
  has_many :results, dependent: :destroy
  serialize :results, Array

end
