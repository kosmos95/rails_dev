class CreateHanuris < ActiveRecord::Migration[5.2]
  def change
    create_table :hanuris do |t|
      
      t.references :user
      
      t.string :title
      t.string :country
      t.string :url1
      t.string :url2
      t.string :url3
      t.string :image
      t.text :description
      
      t.string :url_info
      t.string :sns_urls
      t.boolean :hidden, default: false, null: false
      
      t.timestamps
    end
  end
end
