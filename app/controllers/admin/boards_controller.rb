class Admin::BoardsController < Admin::AdminController

  before_action :set_board, only: [:show, :edit, :update, :destroy]
  before_action :init_values

  # GET /boards
  # GET /boards.json
  def index

    do_board_group_list 
    
    do_index_actions() 
    
    #byebug 
    
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
  end

  # GET /boards/new
  def new
    @board = Board.new
  end

  # GET /boards/1/edit
  def edit
  end

  # POST /boards
  # POST /boards.json
  def create
    @board = Board.new(board_params)
    
    respond_to do |format|
      
      #do_board_role_actions
      
      if @board.save 
        format.html { redirect_to url:[:admin, @board], notice: 'Board was successfully created.' }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boards/1
  # PATCH/PUT /boards/1.json
  def update

    respond_to do |format|
      
      #msg = do_board_role_actions
      
      if @board.update(board_params)     
        format.html { redirect_to url: [:admin, @board], notice: 'Board was successfully updated.' }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    @board.destroy
    respond_to do |format|
      format.html { redirect_to admin_boards_path, notice: 'board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  
  # POST /admin/process
  # POST /admin/process.json
  def proc
  
    selected = params[:selected_boards]
    act = params[:act]
    target_board_group_id = params[:target_board_group_id]
    #target_category = params[:target_category]
    
    case act
    
    when 'multi_hide'
      Board.where('id in (?)', selected).update_all('hidden = 1')      
      redirect_back fallback_location: admin_boards_path, notice: '게시판 숨김처리(접근금지) 되었습니다.'
    
    when 'multi_unhide'
      Board.where('id in (?)', selected).update_all('hidden = 0')
      redirect_back fallback_location: admin_boards_path, notice: '게시판 공개처리 되었습니다.'

    when 'multi_enable_display'
      Board.where('id in (?)', selected).update_all('display = 1')      
      redirect_back fallback_location: admin_boards_path, notice: '게시판이 첫화면 목록에 나옵니다.'
    
    when 'multi_disable_display'
      Board.where('id in (?)', selected).update_all('display = 0')
      redirect_back fallback_location: admin_boards_path, notice: '게시판이 첫화면 목록에 나오지 않습니다.'
      
    when 'multi_board_group_change'
      selected.each { |board_id|
        board = Board.find(board_id)
        board.board_group_id = target_board_group_id
        board.save
        
        # 딸린 post에도 board_group 변경 
        board.post_group_change(target_board_group_id)
      }
      redirect_back fallback_location: admin_boards_path, notice: '게시판 그룹이 변경되었습니다.'

    else
      puts "unprocessed: " + act 
    end
    
  end 
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id])
    end
    
    def init_values 
      @level_opions = [ ['비회원', 0] ]
      @level_opions += Level.all.map { |x| [x.name, x.level] }.sort { |x,y| x[1] <=> y[1] }    
      
      #@board_managers = @board.moderators
    end 

    # Never trust parameters from the scary internet, only allow the white list through.
    def board_params
      #pp params 
      params[:board][:bid]&.strip!
      params[:board][:name]&.strip!
      params.require(:board).permit(:bid, :name, :category, :board_group_id, :board_managers,
        :minlevel_index, :minlevel_show, :minlevel_create, :minlevel_download)
    end
    
    def do_index_actions 
      
      #관리하는 게시판 
      #@moderating_board_ids = Board.board_ids_of_my_moderating(current_user)

      @recnum = params[:recnum].present? ? params[:recnum].to_i : 15 
      @where = params[:where] || 'name'
      @page = params[:page].present? ? params[:page].to_i : 1
      @hidden = (params[:hidden] || '0').to_i
      @display = (params[:display] || '1').to_i
      @keyword = params[:keyword] || ''
      @board_group_id = params[:board_group_id] || ""
      @sort = params[:sort] || "id"
      @orderby = params[:orderby] || "ASC"

      where_list = %w(name bid)
      
      where_str = "1 "
      where_str += "AND (board_group_id = #{@board_group_id}) " if @board_group_id != ''
      #m_bids_str = @moderating_board_ids.join(",")
      #if @moderating_board_ids.length > 0 then 
      #  where_str += "AND (board_id in (#{m_bids_str})) " 
      #else 
      #  where_str += "AND (0)"
      #end 
      #where_str += "AND notice=1 " if @notice > 0
      where_str += "AND hidden=1 " if @hidden > 0
      where_str += "AND display=0 " if @display == 0

      where1 = where_list.include?(params[:where]) ? params[:where] : 'name'
      where_str += "AND (#{where1} like '%#{@keyword}%')" if @keyword != ''

      @total_count = Board.where(where_str).count 
      @total_page_num = @total_count / @recnum + 1 
      @boards = Board.where("#{where_str} ").order("#{@sort} #{@orderby}")
        .paginate(:page => params[:page], :per_page => @recnum, :total_entries => @total_count)
        
    end 
    
    def do_board_group_list
      # @managing_board_ids = Board.board_ids_of_my_moderating(current_user)
      # @managing_boards = @managing_board_ids.map { |bid| Board.find(bid) }
      # @board_id = params[:board_id] || ""  
      # @boards = @managing_boards # Board.all 
      # if @boards.length == 0 && current_user.admin_group?
        # @boards = Board.all 
      # end 
      @board_groups = BoardGroup.all
      @board_group_options = @board_groups.collect { |x| ["[#{x.id}] #{x.name}", x.id] }
      @board_group_options.unshift ['=== 게시판그룹 선택 ===', '']
    end
    
    # def do_board_role_actions
    
      # board_managers = params[:board_managers]
      
      # emails = board_managers.split("\n")
        # .map { |x| x.strip }
        # .filter { |x| x != "" }
        # .uniq 
      
      # self.moderators.each { |u|
        # if !emails.include?(u.email.strip) #이메일 항목에 없으면 삭제 
          # u.remove_role :moderator, self
        # end 
      # }
      
      # #board_roles = @board.roles.select { |x| x.name == 'moderator' }
      # #board_roles.each { |r| 
        # #r.users.each { |u| 
          # #if !emails.include?(u.email.strip) #이메일 항목에 없으면 삭제 
          # #  u.remove_role :moderator, @board
          # #end 
        # #}
      # #}
      
      # # 없으면 새로 추가 
      # emails.each { |email| 
        # user = User.where('email = ?', email.strip).first 
        # if !user.nil?
          # if !user.has_role?(:moderator, Board) then 
            # user.add_role :moderator, Board 
          # end
          # if !user.has_strict_role?(:moderator, @board) then 
            # user.add_role :moderator, @board 
          # end 
        # else 
          # @board.errors.messages[:role].push("존재하지 않는 이메일: #{email}")
        # end 
      # }

    # end 
end

