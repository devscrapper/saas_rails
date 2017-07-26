class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :keywords, null: false, default: "no keyword"
      t.string :results, null: false , default: "no result"
      t.timestamps null: false
    end
  end
end
