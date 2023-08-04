class CreateTermTaxonomies < ActiveRecord::Migration[5.2]

  def change
  
    create_table TermTaxonomy.table_name do |t|
      t.string   "taxonomy", index: true
      t.text     "description", limit: 1073741823
      t.integer  "parent_id", index: true
      t.integer  "count"
      t.string   "name"
      t.string   "slug", index: true
      t.integer  "term_group"
      t.integer  "term_order", index: true
      t.string   "status"
      t.timestamps null: false
    end
    
    #INSERT INTO `term_taxonomy` (`id`, `taxonomy`, `description`, `parent_id`, `count`, `name`, `slug`, `term_group`, `term_order`, `status`, `created_at`, `updated_at`) VALUES
	#(1, 'site', NULL, NULL, NULL, 'default', '192.168.0.89:81', NULL, NULL, NULL, '2020-02-08 05:28:27', '2020-02-08 05:28:37'),
	#(2, 'theme', '', 1, NULL, 'default', 'default', NULL, NULL, NULL, '2020-02-09 08:17:29', '2020-02-09 09:07:19');
  
    # s = Site.new(name:'default')
    # s.save! 
    
    # t = Theme.new slug:'default', taxonomy: 'theme', parent_id: s.id
    # t.save! 
    
  end
  
end

