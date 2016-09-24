class Rename < ActiveRecord::Migration
  change_table :captchas do |t|
        t.rename :visitor_id, :visit_id
  end
end
