class CreatePosts < ActiveRecord::Migration[5.2]

  def change
    create_table :posts, id: :integer, primary_key: [:id, :board_id], 
        options: " PARTITION BY HASH(board_id) PARTITIONS 300" do |t|
      
      t.integer :id, null: false, auto_increment: true

      t.float   :gid
      
      t.belongs_to :board_group, index: true, null: false, type: :integer, default: 0
      t.belongs_to :board, index: true, null: false, type: :integer
      t.string  :bid, limit:16, default:""
      
      t.integer :site_id, limit: 1, null: false, default: 0
      t.integer :display, limit: 1, null: false, default: 1
      t.integer :hidden, limit: 1, null: false, default: 0
      t.integer :notice, limit: 1, null: false, default: 0 
      t.integer :depth, limit: 1, null: false, default: 0 
      
      t.belongs_to :user, index: true, type: :integer
      t.string :name, limit: 32
      t.string :nick, limit: 32
      
      t.string :subject, limit: 100
      t.mediumtext :content
      t.string :category, limit: 32
      t.string :html, limit:4, null: false, default: "html"
      t.string :tag, limit: 191 
      #t.string :files, :string
      t.string :source, :string, null: true 
      #t.integer :image_cnt, null: false, default: 0
      t.string :files, limit: 191 
      t.integer :files_cnt, null: false, default: 0

      t.integer :hit, null: false, default: 0 
      t.integer :favor_cnt, null: false, default: 0 
      t.integer :unfavor_cnt, null: false, default: 0 
      t.integer :comment_cnt, null: false, default: 0 
      t.integer :report_cnt, null: false, default: 0 #신고 

      t.string  :ip, limit:25, null: false, default: ''

      t.boolean :deleted, limit: 1, null: false, default: false

      t.timestamps

      t.index :gid 
      t.index :bid 
      t.index :display
      t.index :notice 
      t.index :hidden 
      t.index :deleted 
      t.index :site_id 

    end
	
    change_column :posts, :gid, :double, precesion: "11,2", null: false, default: "0.00"
  end
  
end
