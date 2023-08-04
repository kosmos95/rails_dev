class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :alt
      #t.string :hint, limit:32 
      t.integer :hint, default:0
      t.string :file # 이미지 파일 id + ',' + 이미지 파일 id + ',' + ... 

      t.timestamps
    end
    
    add_index :images, :hint, unique: false 
    
  end
end
