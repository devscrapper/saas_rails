class AddMajoridMinorIdToCaptcha < ActiveRecord::Migration
  def change
    add_column :captchas, :major_id, :string, default: "no id", null: false
    add_column :captchas, :minor_id, :string, default: "no id", null: false
  end
end
