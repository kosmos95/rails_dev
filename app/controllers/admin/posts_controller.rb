class Admin::PostsController < Admin::AdminController

  # GET /admin/posts
  # GET /admin/posts.json
  def index
    
    do_board_list() 
	
    do_boardgroup_list() 
    
    do_category_list()

    do_index_actions() 

    render "admin/posts/index"
    
  end

  # POST /admin/process
  # POST /admin/process.json
  def proc
  
    selected = params[:selected_posts]
    act = params[:act]
    target_board_id = params[:target_board_id]
    target_category = params[:target_category]
    target_board_group_id = params[:target_board_group_id]
    
    case act
    
    when 'multi_delete'
      ActiveRecord::Base.transaction do
        Post.where('id in (?)', selected).destroy_all
      end 
      redirect_back fallback_location: admin_posts_path, notice: '게시물이 삭제되었습니다.'      
    
    when 'multi_hide'
      ActiveRecord::Base.transaction do
        Post.where('id in (?)', selected).update_all('hidden = 1')      
      end 
      redirect_back fallback_location: admin_posts_path, notice: '숨김처리 되었습니다.'      
    
    when 'multi_unhide'
      ActiveRecord::Base.transaction do
        Post.where('id in (?)', selected).update_all('hidden = 0')
      end 
      redirect_back fallback_location: admin_posts_path, notice: '공개처리 되었습니다.'
    
    when 'multi_set_notice'
      ActiveRecord::Base.transaction do
        Post.where('id in (?)', selected).update_all('notice = 1')
      end
      redirect_back fallback_location: admin_posts_path, notice: '공지로 올렸습니다.'      
    
    when 'multi_unset_notice'
      ActiveRecord::Base.transaction do
        Post.where('id in (?)', selected).update_all('notice = 0')
      end 
      redirect_back fallback_location: admin_posts_path, notice: '공지에서 내렸습니다.'
      
    when 'multi_copy'
      board = Board.find(target_board_id)
      if ! board.nil? 
        ActiveRecord::Base.transaction do
          selected.each { |post_id| copy_post(post_id, board) }
        end 
        redirect_back fallback_location: admin_posts_path, notice: '다른 게시판으로 복사 되었습니다.'
      else 
        redirect_back fallback_location: admin_posts_path, notice: '없는 게시판입니다.'
      end 
      
    when 'multi_copy_with_comment'
      board = Board.find(target_board_id)
      if ! board.nil? 
        ActiveRecord::Base.transaction do
          selected.each { |post_id| copy_post(post_id, board, with_comment:true) }
        end
        redirect_back fallback_location: admin_posts_path, notice: '다른 게시판으로 복사 되었습니다.'
      else 
        redirect_back fallback_location: admin_posts_path, notice: '없는 게시판입니다.'
      end       
      
    when 'multi_move'
      board = Board.find(target_board_id) 
      if ! board.nil?
        ActiveRecord::Base.transaction do
          selected.each { |post_id| move_post(post_id, board) }
        end
        redirect_back fallback_location: admin_posts_path, notice: '다른 게시판으로 이동 되었습니다.'
      else 
        redirect_back fallback_location: admin_posts_path, notice: '없는 게시판입니다.'
      end  
	  
    when 'multi_category_move'
      ActiveRecord::Base.transaction do
        selected.each { |post_id| 
          post = Post.find(post_id)
          post.change_category(target_category)
        }
      end
      redirect_back fallback_location: admin_posts_path, notice: '카테고리 변경되었습니다.'
	  
    when 'multi_boardgroup_move'
      ActiveRecord::Base.transaction do
        selected.each { |post_id|
          post = Post.find(post_id)
          post.change_board_group_id(target_board_group_id)
        }
      end
      redirect_back fallback_location: admin_posts_path, notice: '게시판그룹 변경되었습니다.'

    else
      puts "unprocessed: " + act 
    end
    
  end 
    
  private 
  
    def copy_post(post_id, target_board, with_comment = false)
      post = Post.find(post_id)
      if !post.nil? then 
        new_p = !with_comment ? post.dup : post.dup_with_comments
        new_p.board_id = target_board.id
        new_p.board_group_id = target_board.board_group_id
        new_p.bid = target_board.bid
        new_p.save
        
        # update to post_index 
        idx = new_p.post_index 
        idx.board_id = target_board.id
        idx.board_group_id = target_board.board_group_id
        idx.save
      else 
        puts "Unknown post: #{post_id}"
      end
    end 
    
    def move_post(post_id, target_board)
      post = Post.find(post_id)
      if !post.nil? then
        post.board_id = target_board.id
        post.board_group_id = target_board.board_group_id
        post.bid = target_board.bid
        post.save
        
        # update to post_index 
        idx = new_p.post_index 
        idx.board_id = target_board.id
        idx.board_group_id = target_board.board_group_id
        idx.save        
      else
        puts "Unknown post: #{post_id}"
      end
    end 
    
    def do_index_actions 
      
      #관리하는 게시판 
      @moderating_board_ids = Board.board_ids_of_my_moderating(current_user)

      @recnum = params[:recnum].present? ? params[:recnum].to_i : 15 
      @where = params[:where] || 'subject'
      @page = params[:page].present? ? params[:page].to_i : 1
      @notice = params[:notice].to_i || 0
      @hidden = params[:hidden].to_i || 0
      @keyword = params[:keyword] || ''
      @board_id = params[:board_id] || ""
      @sort = params[:sort] || "gid"
      @orderby = params[:orderby] || "ASC"

      where_list = %w(subject content name nick id term)
      
      where_str = "1 "
      where_str += "AND (board_id = #{@board_id}) " if @board_id != ''
      m_bids_str = @moderating_board_ids.join(",")
      if @moderating_board_ids.length > 0 then 
        where_str += "AND (board_id in (#{m_bids_str})) " 
      #else 
      #  where_str += "AND (0)"
      end 
      where_str += "AND notice=1 " if @notice > 0
      where_str += "AND hidden=1 " if @hidden > 0

      where1 = where_list.include?(params[:where]) ? params[:where] : 'subject'
      where_str += "AND (#{where1} like '%#{@keyword}%')" if @keyword != ''

      @total_count = Post.where(where_str).count 
      @total_page_num = @total_count / @recnum + 1 
      @posts = Post.where("#{where_str} ").order("#{@sort} #{@orderby}")
        .paginate(:page => params[:page], :per_page => @recnum, :total_entries => @total_count)
        
    end 
  
    def do_board_list
      @managing_board_ids = Board.board_ids_of_my_moderating(current_user)
      @managing_boards = @managing_board_ids.map { |bid| Board.find(bid) }
      @board_id = params[:board_id] || ""  
      @boards = @managing_boards # Board.all 
      if @boards.length == 0 && current_user.admin_group?
        @boards = Board.all 
      end 
      @board_options = @boards.collect { |x| ["#{x.name} (#{x.bid})", x.id] }
      @board_options.unshift ['=== 게시판 선택 ===', '']
    end
	
	 def do_boardgroup_list
	  @board_group_id = params[:board_group_id] || ""  
	  @board_groups = BoardGroup.all
      @board_groups_options = @board_groups.collect { |x| ["#{x.name} (#{x.bgid})", x.id] }
      @board_groups_options.unshift ['=== 게시판그룹 선택 ===', '']
    end
        
    def do_category_list
    
      @category = params[:category] || ""
      
      if @board_id != '' then 
        @board = Board.find(@board_id)
        unless @board.nil? then 
          categories = @board.category.to_s.split(",").collect { |x| x.strip }
          @category_options = categories.collect { |x| [x, x] }
        end 
      else 
        @category_options = []
      end
      
      @category_options.unshift ['=== 카테고리 선택 ===', '']    
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def posts_params
      #params.require(:board_group).permit(:bgid, :name)
      nil
    end
    
end
