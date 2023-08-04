# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]

  def change
    create_table :users, id: :integer do |t|
    
      ## Database authenticatable
      t.string :email, limit:32, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.string :nick, limit:32, null:false, default:""
      t.string :name, limit:32, null:false, default:""

      t.integer :level, default:1 

      #t.integer :mailing, limit:1, null:false, default:1 
      #t.integer :point
      
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip, limit:25
      t.string   :last_sign_in_ip, limit:25

      ## Confirmable
      t.string   :confirmation_token, limit:100
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email, limit:32 # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token, limit:100 # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.timestamps null: false
      
    end

    add_index :users, :email,                unique: true, length: 32 
    add_index :users, :reset_password_token, unique: true, length: 100
    add_index :users, :confirmation_token,   unique: true, length: 100
    add_index :users, :unlock_token,         unique: true, length: 100
  end
end
