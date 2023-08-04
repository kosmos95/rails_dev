class CreateCommentFavors < ActiveRecord::Migration[5.2]
  def change
    create_table :comment_favors, options: "" do |t|
      t.integer :comment_id
      t.integer :favored_user_id

      t.index :comment_id 
      t.index :favored_user_id 
      
    end
  end
end
