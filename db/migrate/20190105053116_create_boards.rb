class CreateBoards < ActiveRecord::Migration[5.2]

  def change
    create_table :boards, id: :integer do |t|
    
      t.string :bid, limit: 16
      t.string :name, limit: 32
      t.string :short_name, limit: 10
      t.string :category, limit: 191

      #t.integer :post_cnt
      #t.integer :post_notice_cnt

      t.index :bid, unique: true
      t.belongs_to :board_group, index: true, type: :integer

      t.integer :display, limit: 1, null: false, default: 1
      t.integer :hidden, limit: 1, null: false, default: 0
      t.integer :arrange, default: 0  #화면에 보이는 순서

      t.index :display
      t.index :hidden 
      
      t.timestamps
    end
  end
  
end
