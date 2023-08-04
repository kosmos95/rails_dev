class CreateMeta < ActiveRecord::Migration[5.2]
  def change

    create_table "metas" do |t|
      t.string  "key", index: true
      t.text    "value", limit: 1073741823
      t.integer "objectid", index: true
      t.string  "object_class", index: true
    end
    
  end
end
