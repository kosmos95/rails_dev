class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.integer :user_id, null: false 
      t.string :provider
      t.string :uid

      t.timestamps
    end
	
    #add_index :identities, :user_id, unique: true 
    
  end
end
