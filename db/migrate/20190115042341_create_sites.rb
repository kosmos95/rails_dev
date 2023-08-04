class CreateSites < ActiveRecord::Migration[5.2]

  def change
    create_table :sites, id: :integer do |t|
      t.string :name, limit: 32
      t.string :slug, limit: 191
      t.string :description, limit: 191

      t.timestamps      
    end
  end
  
end
