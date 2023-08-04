class CreateUserGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :user_groups, id: :integer do |t|

      t.string :name, limit:32

      t.timestamps
    end
  end
end
