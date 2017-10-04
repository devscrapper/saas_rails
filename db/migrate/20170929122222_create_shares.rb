class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :recipient, null: false
      t.string :tool, null: false

      t.timestamps null: false
    end
  end
end
