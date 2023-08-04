class CreateComments < ActiveRecord::Migration[5.2]

  def change
  
    create_table :comments, id: :integer, primary_key: [:id, :board_id], 
        options: "PARTITION BY HASH(board_id) PARTITIONS 300" do |t|

      t.integer :id, null: false, auto_increment: true

      t.integer :gid 
      t.belongs_to :board, index: true, null: false, type: :integer
      t.integer :parent_id, null: false, default:0
      t.string :reply_order, limit:20, null: false, default:""
      
      t.string :name, limit:32, null: false, default: ""
      t.string :nick, limit:32, null: false, default: ""
      t.text :content
      t.string :image, default: nil
      t.integer :img_pos, null: false, default:0
      
      t.string :html, limit:4, null: false, default: "html"
      t.string :ip, limit:25, null: false, default: ''
      
      t.belongs_to :user, index: true, type: :integer
      t.belongs_to :post, index: true, type: :integer
      
      t.integer :score1, null: false, default: 0
      t.integer :score2, null: false, default: 0
      t.integer :report_cnt, null: false, default: 0 #신고 
      t.integer :favor_cnt, null: false, default:0  #추천
      t.integer :unfavor_cnt, null: false, default:0  #추천
	  
      t.integer :deleted, limit:1, default:0 
      
      t.index :gid 
      t.index :parent_id 
      t.index :deleted 

      t.timestamps
    end
  
  end

end
