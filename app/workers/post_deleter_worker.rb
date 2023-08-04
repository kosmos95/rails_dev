class PostDeleterWorker
  include Sidekiq::Worker

  def perform(operation, board_id)
    logger.info [operation, "ID: #{board_id}"]

    count = Post.where(board_id: board_id).count 
    while count > 0
      logger.info [operation, "ID: #{board_id} ==> deleting 1000 posts (left: #{count})"]
      Multidb.use(:master) do 
        begin Post.where(board_id: board_id).take(1000).each do |p| 
          p.destroy; end
        rescue ActiveRecord::RecordNotFound => e; end 
      end 
      sleep 2
      count = Post.where(board_id: board_id).count 
    end
    
  end
  
end
