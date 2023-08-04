class AddReferenceToUserGroupToUser < ActiveRecord::Migration[5.2]
  def change  
    add_column :users, :user_group_id, :integer    
    
    add_index :users, :user_group_id, unique: false
  end
end
