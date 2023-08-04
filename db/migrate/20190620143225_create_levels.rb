class CreateLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :levels do |t|

      t.integer :site_id 
      
      t.integer :level
      t.string  :name, limit: 32 
      
      t.boolean :enable_autoupgrade, null: false, default: false 
      t.integer :autoupgrade_login_num, null: false, default: 0
      t.integer :autoupgrade_post_num, null: false, default: 0
      t.integer :autoupgrade_comment_num, null: false, default: 0
      t.integer :autoupgrade_visit_days, null: false, default: 0

      t.timestamps
    end
  end
end

#등급	회원수	명칭	회원등급 자동갱신 수량설정
#                   (접속수)	(게시물수)	(댓글수)

