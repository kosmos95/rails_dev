class CreateBoardGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :board_groups, id: :integer  do |t|

      t.string :bgid, limit:16, null: false, unique: true 
      t.string :name, limit:32
      t.string :short_name, limit:10

      t.timestamps

      t.index :bgid, unique: true
      
    end


  end
end


# kimsq's 
# CREATE TABLE `rb_bbs_index` (
# 	`site` INT(11) NOT NULL DEFAULT '0',
# 	`notice` TINYINT(4) NOT NULL DEFAULT '0',
# 	`bbs` INT(11) NOT NULL DEFAULT '0',
# 	`gid` DOUBLE(11,2) NOT NULL DEFAULT '0',
# 	INDEX `site` (`site`),
# 	INDEX `notice` (`notice`),
# 	INDEX `bbs` (`bbs`, `gid`),
# 	INDEX `gid` (`gid`)
# )
# COLLATE='utf8_general_ci'
# ENGINE=MyISAM
# ;
