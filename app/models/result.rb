class Result < ActiveRecord::Base
  belongs_to :search
  serialize :results, Array



end
