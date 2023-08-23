class CreateNewMenus < ActiveRecord::Migration[6.1]
  def change
    create_table :new_menus do |t|
      t.string :name
      t.string :link

      t.timestamps
    end
  end
end
