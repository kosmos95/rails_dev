class CreatePostFavors < ActiveRecord::Migration[5.2]
  def change
    create_table :post_favors, options: "" do |t|
      t.integer :post_id
      t.integer :favored_user_id

      t.index :post_id 
      t.index :favored_user_id 
      
    end
  end
end
