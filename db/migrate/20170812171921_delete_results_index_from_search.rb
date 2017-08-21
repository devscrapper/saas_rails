class DeleteResultsIndexFromSearch < ActiveRecord::Migration
  def change
    remove_column   :searches, :results
    remove_column :searches, :index
  end
end
