json.extract! board, :id, :bid, :name, :category, :num_r, :created_at, :updated_at
json.url board_url(board, format: :json)
