class CreatePostIndices < ActiveRecord::Migration[5.2]
  def change
    create_table :post_indices, id: :integer, primary_key: [:post_id], options: "" do |t|
          
      #t.integer :id, null: false, auto_increment: true
      t.belongs_to :post, index: true, null: false, type: :integer 

      t.float   :gid, null: false
      
      t.belongs_to :board, index: true, null: false, type: :integer
      t.belongs_to :board_group, index: true, null: false, type: :integer, default: 0
      t.belongs_to :user, index: true, null: false, type: :integer, default: 0

      t.belongs_to :site, index: true, null: false, type: :integer
      t.integer :notice, limit: 1, null: false, default: 0 
      t.boolean :deleted, limit: 1, null: false, default: false
      t.string :category, limit: 30 
       
      t.index :gid 
      t.index :notice 
      t.index :deleted 
      t.index :category

      #t.timestamps
    end

    change_column :post_indices, :gid, :double, precesion: "11,2", null: false, default: "0.00"        
  end
end
