class CreatePointLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :point_logs do |t|
      t.belongs_to :user, index: true, type: :integer      
      t.integer :by_user_id, null: false, default:0
      t.integer :point, null: false, default:0
      t.string :reason

      #t.timestamps
      t.column :created_at, :datetime      
    end
  end
end
