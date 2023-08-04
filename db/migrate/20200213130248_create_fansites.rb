class CreateFansites < ActiveRecord::Migration[5.2]
  def change
    create_table :fansites do |t|
    
      t.references :user 
      t.string :title
      t.string :site_type, index: true 
      t.string :country, index: true 
      t.text :image
      t.string :url1
      t.string :url2
      t.string :url3
      t.text :description
      t.string :address 
      
      
      t.timestamps
    end
  end
end
