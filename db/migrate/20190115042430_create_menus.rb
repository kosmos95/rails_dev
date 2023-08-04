class CreateMenus < ActiveRecord::Migration[5.2]

  def change
    create_table :menus, id: :integer do |t|
      t.string :name, limit:32
      t.text :content
      #t.references :site
      #t.integer :site_id 

      t.timestamps

      t.belongs_to :site, index: true, type: :integer
      t.index :name, unique: true
    end
  end

end
