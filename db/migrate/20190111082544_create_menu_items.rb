class CreateMenuItems < ActiveRecord::Migration[5.2]

  def change
    create_table :menu_items, id: :integer do |t|
      t.references :menu, type: :integer
      t.integer :parent_id
      t.string :url
      t.string :target, limit:16
      t.string :type, limit:16
      t.integer :ordering
      t.integer :activated

      t.timestamps
    end
  end

end
