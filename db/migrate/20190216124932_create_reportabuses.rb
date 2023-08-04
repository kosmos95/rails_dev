class CreateReportabuses < ActiveRecord::Migration[5.2]
  def change
    create_table :reportabuses, id: :integer, options: "" do |t|
      t.integer :user_id, null: false
      t.integer :target_type, null: false, default:0
      t.integer :target_id
      t.string :reason, limit: 100
      t.integer :action_type 
      t.string :memo, limit: 100

      t.timestamps
    end
  end
end
