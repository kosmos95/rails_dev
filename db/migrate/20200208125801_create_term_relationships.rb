class CreateTermRelationships < ActiveRecord::Migration[5.2]
  
  def change  
    create_table :term_relationships do |t|
      t.integer "objectid", index: true
      t.integer "term_order", index: true
      t.belongs_to :term_taxonomy, index: true
    end
  end
  
end
