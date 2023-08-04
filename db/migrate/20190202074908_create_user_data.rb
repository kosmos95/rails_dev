class CreateUserData < ActiveRecord::Migration[5.2]
  def change
    create_table :user_data, id: :integer do |t|

      t.belongs_to :user, index: true, type: :integer
    
      t.boolean :mailing, null:false, default:true 
      t.integer :point
      
      t.string :avatar

      #t.timestamps
    end
  end
end
