class CreateCaptchas < ActiveRecord::Migration
  def change
    create_table :captchas do |t|
      t.string :visitor_id, null: false
      t.string :image_file_id, null: false
      t.string :value, null: false, default: "unknown"
      t.timestamps null: false
    end
  end
end
