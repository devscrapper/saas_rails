class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :keywords, null: false, default: "no keyword"
      t.text :results, null: false , default: nil
      t.integer :index, null: false, default: 1
      t.belongs_to :search, index: true, null: false
      t.timestamps null: false
    end
  end
end
