class AddRoleDataToUserData < ActiveRecord::Migration[5.2]
  def change
    add_column :user_data, :lvl_login_cnt, :integer, default:0
    add_column :user_data, :lvl_post_cnt, :integer, default:0
    add_column :user_data, :lvl_comment_cnt, :integer, default:0
    add_column :user_data, :lvl_visit_days, :integer, default:0
  end
end
