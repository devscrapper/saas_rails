class ChangePropertiesToTextInSearch < ActiveRecord::Migration
  def change
    change_column_default(:searches, :results, nil)
    change_column :searches, :results, :text
  end
end
