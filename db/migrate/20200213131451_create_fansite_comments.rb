class CreateFansiteComments < ActiveRecord::Migration[5.2]
  def change
  
    create_table :fansite_comments do |t|
      t.references :fansite, index: true 
      t.references :user, index: true 
      t.string :content
      
      t.timestamps
    end
    
    #add_reference :fansite_comments, :fansite, index: true
    #add_reference :fansite_comments, :user, index: true 

  end
end
