json.extract! post, :id, :gid, :board_id, :bid, :display, :hidden, :notice, :name, :nick, :user_id, :subject, :category, :content, :html, :tag, :hit, :comment, :created_at, :updated_at
json.url post_url(post, format: :json)
