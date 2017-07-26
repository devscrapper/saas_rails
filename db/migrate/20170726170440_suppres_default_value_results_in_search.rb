class SuppresDefaultValueResultsInSearch < ActiveRecord::Migration
  def change
    change_column_default(:searches, :results, nil)
  end
end
