class AddIndexInSearch < ActiveRecord::Migration
  def change
    add_column :searches, :index, :integer, default: 1, null: false
  end
end
