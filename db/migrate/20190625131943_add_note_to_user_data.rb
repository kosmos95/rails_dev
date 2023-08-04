class AddNoteToUserData < ActiveRecord::Migration[5.2]
  def change
    add_column :user_data, :note, :string
  end
end
