class CreateUserLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_logs do |t|

      t.belongs_to :user, index: true, type: :integer
      t.boolean :success, null:false, default:true 
      t.string :event_name, limit:16
      t.string :reason, limit: 100
      t.string :ip, limit:16
      t.string :useragent, limit: 100
      t.string :url, limit: 100
      t.string :referer, limit: 100
      
      #t.timestamps
      t.column :created_at, :datetime
    end
  end
end
