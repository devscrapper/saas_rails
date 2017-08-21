class AddCountsDelayInResults < ActiveRecord::Migration
  def change
    add_column :results, :count_results, :integer, default: 0, null: false
    add_column :results, :delay, :integer, default: 0, null: false
  end
end
