class CustomFields < ActiveRecord::Migration[5.2]
  def change
  
    create_table "custom_fields" do |t|
      t.string  "object_class", index: true
      t.string  "name"
      t.string  "slug", index: true
      t.integer  "objectid", index: true
      t.integer "parent_id", index: true
      t.integer "field_order"
      t.integer "count", default: 0
      t.boolean "is_repeat", default: false
      t.text    "description"
      t.string  "status"
    end

    create_table "custom_fields_relationships" do |t|
      t.integer "objectid", index: true
      t.integer "custom_field_id", index: true
      t.integer "term_order"
      t.string  "object_class", index: true
      t.text    "value", limit: 1073741823
      t.string  "custom_field_slug", index: true
    end

  end
end
