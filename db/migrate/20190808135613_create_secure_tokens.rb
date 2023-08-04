class CreateSecureTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :secure_tokens do |t|
      t.integer :user_id 
      t.string :token

      t.timestamps
    end
	
	add_index :secure_tokens, :user_id, unique: true 
  end
end
