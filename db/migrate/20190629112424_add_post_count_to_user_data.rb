class AddPostCountToUserData < ActiveRecord::Migration[5.2]
  def change
    add_column :user_data, :total_post_cnt, :integer, default:0
    add_column :user_data, :total_cmt_cnt, :integer, default:0
  end
end
