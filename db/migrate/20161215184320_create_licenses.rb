class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|

      t.timestamps null: false
    end
  end
end
