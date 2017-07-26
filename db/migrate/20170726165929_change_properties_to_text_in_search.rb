class ChangePropertiesToTextInSearch < ActiveRecord::Migration
  def change
    change_column :searches, :results, :text
  end
end
