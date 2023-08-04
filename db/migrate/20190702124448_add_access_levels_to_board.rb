class AddAccessLevelsToBoard < ActiveRecord::Migration[5.2]

  def change  
    add_column :boards, :minlevel_index, :tinyint, limit:4, default:0
    add_column :boards, :minlevel_show, :tinyint, limit:4, default:0
    add_column :boards, :minlevel_create, :tinyint, limit:4, default:1
    add_column :boards, :minlevel_download, :tinyint, limit:4, default:0
  end
  
end
