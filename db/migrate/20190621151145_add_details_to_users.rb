class AddDetailsToUsers < ActiveRecord::Migration[5.2]
  
  def change  
  
    change_table :users do |t|
      #t.remove :description, :name
      #t.string :part_number
      #t.index :part_number
      #t.rename :upccode, :upc_code
      
      # 정지회원 
      t.boolean :stopped, default: false
      t.datetime :stopped_at
      
      # 자동 업그레이드 제외 
      t.boolean :exclude_autoupgrade, default: false
    end
    
  end
end


# rails migration types 
# https://stackoverflow.com/questions/17918117/rails-4-list-of-available-datatypes/25702629
# 
# :binary
# :boolean
# :date
# :datetime
# :decimal
# :float
# :integer
# :bigint
# :primary_key
# :references
# :string
# :text
# :time
# :timestamp
#
