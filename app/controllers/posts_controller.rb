class PostsController < ApplicationController

  DEFAULT_SKIN = 'default'
  
  around_action :run_using_slave, only: [:index, :show, :edit, :set_board, :set_post, :set_board_group]
  
  before_action :check_recaptcha_enabled, only: [:create, :new, :create, :edit]
  before_action :set_board, except: [:home, :perm_denied, :group_index]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :favor]
  before_action :set_board_group, only: [:group_index]
  #rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  #after_action :expire_cache, only: [:create, :update, :destroy]

  #mount_uploaders :files, EditorUploader

  # cancancan에서 user 로그인 상태를 체크하므로 check_user는 불필요
  # before_action :check_user, only: [:edit, :update, :destroy]

  # index와 show action을 제외한 모든 action은 로그인이 필요함
  before_action :authenticate_user!, except: [:index, :group_index, :show]
  #before_action :authenticate_user!
  
  # cancancan으로 posts의 authorization을 처리하겠다는 의미
  load_and_authorize_resource
  
  #skip_authorize_resource :only => :home 
  CACHING_PAGES = 500 
  
  
  # GET /posts
  # GET /posts.json
  def index
    #board_id = params[:board_id]

    return if perm_denied_for :index 
    
    @title = @board.name 
    
    do_index_actions() 
    
    render "posts/#{@skin}/index"    
  end
  
  def group_index 

    return if perm_denied_for :index 
    
    @title = @board_group.name 
    
    do_group_index_actions()
    
    render "posts/#{@skin}/group_index"    
  
  end 


  # GET /posts/1
  # GET /posts/1.json
  def show
    
    authorize! :read, @post

    return if perm_denied_for :show

    @total_hit = inc_total_hit_in_session()
    #if !check_if_bot_request && # 검색엔진은 그냥 통과 
    #    session[:user_id].nil? # 로그인했으면 무시 
    #then
    #    return if encourage_login?
    #end

    #@post  = Post.find(params[:id])
    #@board = Board.find(@post.board_id)
    #@bid   = @board.bid
    @skin  = @post.board[:skin] || DEFAULT_SKIN
    @ogimage = image_url_fix(@post.get_ogimage)
    @title = @post.subject

    run_using_master do 
      inc_hit 
    end 

    do_index_actions()
    
    render "posts/#{@skin}/show"
  end

  # GET /posts/new
  def new
  
    return if perm_denied_for :create 

    @post = Post.new
    @reply = params[:reply] 
    @id = params[:id]
    if !@id.nil?
      @parent_post = Post.find(@id)
    end
    @title = t("hcafe2.post.new_post")
    @category_select_arr = @category_arr.collect { |x| [x.to_s, x] }
    @category_select_arr.unshift ["=== 분류 선택 ===", ""]

    render "posts/#{@skin}/new"
  end

  # GET /posts/1/edit
  def edit
  
    return if perm_denied_for :create 
  
    @reply = params[:reply]
    #@files = "1,2,3,4"
    @title = "#{t("hcafe2.post.edit")} - #{@post.subject}"
    @category_select_arr = @category_arr.collect { |x| [x.to_s, x] }
    @category_select_arr.unshift ["=== 분류 선택 ===", ""]

    render "posts/#{@skin}/edit"
  end

  # POST /posts
  # POST /posts.json
  def create
  
    return if perm_denied_for :create 
  
    Throttling.for(:post_create).check(:user_id, current_user.id) do
      # Do your stuff here
      #raise Exception.new("최대 1분에 1개 게시물을 생성할수 있습니다.")
      #return 
      redirect_to root_path(), notice: t("hcafe2.post.max_post_creation_limit_msg", min: 1, count: 1)
    end
    if @recaptcha_enabled
      # v2 checkbox 
      recaptcha_valid = verify_recaptcha(model: @post)
      # v3
      #recaptcha_valid = verify_recaptcha(model: @post, action: 'post_write')
      if !recaptcha_valid
        redirect_to board_posts_path(@bid), notice: t("hcafe2.post.captcha_check_failed")
        return 
      end
    end 
    @post = Post.new(post_params) 
    @post.ip = request.remote_ip 
    @post.ip = request.env['HTTP_X_REAL_IP'] || request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip if  @post.ip == '127.0.0.1'
    current_user.data.incr_level_upgrade_value(:post_cnt)
    current_user.data.incr_count_value(:total_post_cnt)

    respond_to do |format| 
      if @post.save 
        #format.html { redirect_to board_posts_path(@bid), notice: '게시물이 등록되었습니다.' }
        format.html { redirect_to board_post_path(@bid, @post.id), notice: t('hcafe2.post.new_post_created') }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render "posts/#{@skin}/new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update

    return if perm_denied_for :create 

    page = params[:page] 
    
    respond_to do |format|
      if @post.update(post_update_params)
        format.html { redirect_to board_post_path(@post.bid, @post.id, { page: page }), notice: t('hcafe2.post.post_modified') }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render "posts/#{@skin}/edit", { page: page }}
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    return if perm_denied_for :create 
    @post.destroy
    respond_to do |format|
      format.html { redirect_to board_posts_path(@board.bid), notice: '게시물이 삭제되었습니다.' }
      format.json { head :no_content }
    end
  end
  
  def favor 
    authorize! :read, @post
    
    @favor_added = 0 
    
    @favor_cnt = @post.post_favors.where('favored_user_id=?', current_user.id).count 
    
    if @favor_cnt == 0 
      @post.favor_cnt ||= 0 
      @post.favor_cnt += 1 
      @post.save 
      
      favors = @post.post_favors.new
      favors.favored_user_id = current_user.id
      favors.save
      
      @favor_added = 1
    end 
    
  end 
  
  def perm_denied
  end 

  private

    def check_recaptcha_enabled 
      @recaptcha_enabled = false 
      return
      
      # if Rails.env != 'development' && (request.remote_ip =~ /^(127\.0\.|192\.168\.)/).nil? 
        # @recaptcha_enabled = true 
      # else 
        # @recaptcha_enabled = false 
      # end 
    end 
    
    def do_index_actions 
      @recnum = Post::PER_PAGE 
      @page = (params[:page] || '1').to_i
      @page = @page > 0 ? @page : 1
      #if @page <= 0 
      #redirect_to board_posts_path(@bid)
      #return
      #end

      @use_page_table = (@page >= Post::PAGING_TABLE_MIN_PAGE)
      @keyword = params[:keyword]
      @sort = params[:sort] || 'gid'
      @order = params[:order] || 'asc'
      
      @where = params[:where]
      wherestrs = %w(subject content subject|content name nick id term)
      @where = wherestrs.include?(@where) ? @where : 'subject'
      
      if !@keyword.nil? then 
        #### use MariaDB select 
        # keyword1 = @keyword
        # where1 = where_list.include?(params[:where]) ? params[:where] : 'subject'
        # where_str = "(#{where1} like '%#{keyword1}%')"
        
        # @posts_notice = Post.where("board_id = ? AND notice=1 AND #{where_str}", @board_id).order("gid")
        # @notice_count = @posts_notice.count
        # @total_count = Post.where("board_id = ? AND #{where_str}", @board_id).count 
        # page_max = (@total_count / @recnum) + 1
        # @page = page_max if @page > page_max
        # @posts = Post.where("board_id = ? AND notice=0 AND #{where_str}", @board_id).order("gid")
          # .paginate(:page => @page, :per_page => @recnum, :total_entries => @total_count)

        # Use Elastic Search 
        
        @recnum = 25 
        WillPaginate.per_page = @recnum
        
        keyword1 = @keyword
        where_list = @where.split("|").map(&:strip)
        response = Post.search(keyword1, where_list, @board_id, @page, @recnum)

        @post_indices_notice = nil
        @posts_notice = nil 
        @notice_count = 0
        
        begin 
          @total_count = response.results.total 
          @response_took = response.took 
          page_max = (@total_count / @recnum) + 1
          @page = page_max if @page > page_max
          @posts = response.page(@page).records
        rescue Elasticsearch::Transport::Transport::Errors::NotFound
          @total_count = 0 
          @response_took = 0
          @posts = response.records
        end
        
      else

        @post_indices_notice = Rails.cache.fetch("posts/list_notice/#{@board_id}/#{@category}", expires_in: 5.minutes) do
          query = PostIndex.where("board_id = ? AND notice=1", @board_id)
          query = query.where("category = ?", @category) unless @category.nil?
          query.order("gid")
        end
        
        @notice_count = Rails.cache.fetch("posts/notice_cnt/#{@board_id}", expires_in: 5.minutes) do 
          @post_indices_notice.count
        end || 0
        
        @total_count = Rails.cache.fetch("posts/total_cnt/#{@board_id}", expires_in: 5.minutes) do 
          PostIndex.where("board_id = ?", @board_id).count
        end || 0

        page_max = (@total_count / @recnum) + 1
        @page = page_max if @page > page_max 
                
        #logger.debug "do_index_actions: #{@use_page_table}"
        
        #if @page <= Post::CACHING_PAGES
          post_paging_class = prepare_paging_table(PAGING_TARGET_BOARD) if @use_page_table 
          # Rails.cache.fetch("posts/list/#{@board_id}/#{@page}", expires_in: 5.minutes) do
          query = PostIndex.includes(:user)
            .where("board_id = ? AND notice=0", @board_id)
          query = query.where("category = ?", @category) unless @category.nil?
          query = query.order("gid")
          @post_indices = query.paginate(:page => @page, :per_page => @recnum, :total_entries => @total_count,
              :use_paging_table => @use_page_table, :paging_table_provider => post_paging_class, :paging_key => :gid)
          #end
        #else
          #post_paging_class = prepare_paging_table(PAGING_TARGET_BOARD) if @use_page_table 
          #@post_indices = PostIndex.where("board_id = ? AND notice=0", @board_id).order("gid")
          #    .paginate(:page => @page, :per_page => @recnum, :total_entries => @total_count,
          #      :use_paging_table => @use_page_table, :paging_table_provider => post_paging_class, :paging_key => :gid)
        #end
      end

      @total_count ||= 0
      
      #byebug 

    end 
    
    def do_group_index_actions
    
      @recnum = Post::PER_PAGE  
      @page = (params[:page].present? ? params[:page] : '1').to_i 
      @page = @page > 0 ? @page : 1

      @use_page_table = (@page >= Post::PAGING_TABLE_MIN_PAGE)  

      @post_indices_notice = Rails.cache.fetch("posts/group_list_notice/#{@board_group_id}", expires_in: 5.minutes) do
        PostIndex.where("board_group_id=? AND notice=1", @board_group_id).order("gid")
      end
      
      @notice_count = Rails.cache.fetch("posts/group_notice_cnt/#{@board_group_id}", expires_in: 5.minutes) do 
        @post_indices_notice.count
      end || 0
      
      @total_count = Rails.cache.fetch("posts/group_total_cnt/#{@board_group_id}", expires_in: 5.minutes) do 
        PostIndex.where("board_group_id=?", @board_group_id).count 
      end || 0
      
      #if @page <= Post::CACHING_PAGES
        post_paging_class = prepare_paging_table(PAGING_TARGET_GROUP) if @use_page_table 
        @post_indices = #Rails.cache.fetch("posts/group_list/#{@board_group_id}/#{@page}", expires_in: 5.minutes) do 
          PostIndex.where("board_group_id=? AND notice=0", @board_group_id).order("gid")
            .paginate(:page => @page, :per_page => @recnum, :total_entries => @total_count, 
              :use_paging_table => @use_page_table, :paging_table_provider => post_paging_class, :paging_key => :gid)
        #end
      #else
      #  post_paging_class = prepare_paging_table(PAGING_TARGET_GROUP) if @use_page_table 
      #  @post_indices = PostIndex.where("board_group_id=? AND notice=0", @board_group_id).order("gid")
      #    .paginate(:page => @page, :per_page => @recnum, :total_entries => @total_count, 
      #      :use_paging_table => @use_page_table, :paging_table_provider => post_paging_class, :paging_key => :gid)
      #end
      
      @total_count ||= 0

    end 


    def prepare_paging_table(target)
      # target : 0: board, 1: group 

      @use_momorydb = false #Setting.paging_table_use_momorydb 

      cache_key = paging_table_cache_key(target)

      post_paging_class = PostPaging.get_paging_class(board_id: @board_id, board_group_id: @board_group_id, orderby: "gid", recnum: @recnum, notice: @notice, keyword: @keyword, use_momorydb: @use_momorydb)
      
      if !paging_table_valid?(cache_key) || 
        !post_paging_class.table_exists? || # 테이블이 존재하지 않거나 
        post_paging_class.empty? # momory db 일 경우 개수 매번 확인(최소 1 이상이어야 함) (mysql 재시작시 전체 날라가기 때문) 
      then 
        post_paging_class.create_paging_table
        Rails.cache.write(cache_key, Time.now, expires_in: 1.day)
      end
      
      post_paging_class
      
    end
    
    def paging_table_cache_key(target) 
      case target 
      when PAGING_TARGET_BOARD
        "posts/board/#{@board_id}/postcache_created_at" 
      when PAGING_TARGET_GROUP
        "posts/board_group/#{@board_group_id}/postcache_created_at"
      else 
        raise "Unknown paging table target"
      end
    end 
    
    def paging_table_valid?(cache_key)
        
      postcache_created_at = Rails.cache.fetch(cache_key) { nil }

      # 최대 1분동안 valid 상태 유지됨. 즉 3분에 1번 이상 table 생성 못함. 
      !postcache_created_at.nil? && (Time.now - postcache_created_at) < 3.minute

    end 
    
    def set_board
      #board_id = params[:board_id] || (params[:post] && post_params[:board_id])
      @bid = params[:bid] || (params[:post] && post_params[:bid])
      @board = Board.cached_board_by_bid(@bid)
      @category = params[:cat]
      category_str = @board&.category&.to_s || ""
      @category_arr = category_str.split(',').map(&:strip).select { |x| x!='' }
      #@category_arr.unshift ""

      #raise ActiveRecord::RecordNotFound unless @board.present?
      unless @board.present?
        redirect_to root_path(), notice: t('hcafe2.post.no_such_board')
      end 

      if @board.present? 
        @board_id = @board.id
        @skin = (@board[:skin] || DEFAULT_SKIN)
      else
        @skin= DEFAULT_SKIN 
      end

    #rescue ActiveRecord::RecordNotFound => e 
    #  raise "없는 게시판입니다: #{e}"
    end
    
    def set_board_group 
    
      @bgid = params[:bgid]
      @board_group = BoardGroup.find_by(bgid: @bgid)
      
      #raise ActiveRecord::RecordNotFound unless @board_group.present?
      unless @board_group.present?
        redirect_to root_path(), notice: t('hcafe2.post.no_such_boardgroup')
      end 

      if @board_group.present? 
        @board_group_id = @board_group.id
        @skin = DEFAULT_SKIN # (@board[:skin] || DEFAULT_SKIN)
      else
        @skin= DEFAULT_SKIN 
      end 

    #rescue ActiveRecord::RecordNotFound => e 
    #  raise "없는 게시판 그룹입니다: #{e}" 
    end 
  
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
      #fresh_when(last_modified: @post.updated_at&.utc || @post.created_at&.utc)
    rescue ActiveRecord::RecordNotFound => e 
      #raise "없는 게시물입니다: #{e}" 
      redirect_to root_path(), notice: t('hcafe2.post.no_such_post')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      a = params.require(:post).permit(:gid, :board_id, :bid, :display, :hidden, :notice, 
          :name, :nick, :user_id, 
          :subject, :category, :content, :html, :tag, :hit, :comment, :source, 
          :reply, :parent_post_id, :files)

      a[:name] ||= current_user.name
      a[:nick] ||= current_user.nick
      a[:board_group_id] = @board.board_group_id if !@board.nil?
      a 
    end	

    def post_update_params
      a = params.require(:post).permit(:gid, :board_id, :bid, :display, :hidden, :notice,
          :subject, :category, :content, :html, :tag, :hit, :comment, :source, 
          :reply, :parent_post_id, :files) 
      a[:board_group_id] = @board.board_group_id if !@board.nil?
      a 
    end	

    def inc_hit
      if first_read_in_session then 
        @post.hit += 1 
        @post.simple_update_mode = true 
        @post.save 
        @post.simple_update_mode = false 
        check_as_read_in_session
      end 
    end

    def inc_total_hit_in_session
      session[:post_view_cnt] ||= 0 
      session[:post_view_cnt] += 1
      #logger.debug "################## count: " + session[:post_view_cnt].to_s 
      #session[:post_view_cnt]
    end 

    def first_read_in_session
      session[:post_view] ||= "" 
      session[:post_view].index("[#{@post.id}]").nil?
    end 

    def check_as_read_in_session
      session[:post_view] += "[#{@post.id}]"
    end
    
    def handle_record_not_found 
      render :not_found 
    end 
    
    def user_can_advance?(user, action) 
      return false if (@board || @board_group).nil?
            
      case action 
      when :index
        #return user.level >= @board&.minlevel_index || !@board_group.nil?
        return (!@board.nil? && user.level >= @board&.minlevel_index) || 
               !@board_group.nil?
      when :show 
        return user.level >= @board&.minlevel_show
      when :create 
        return user.level >= @board&.minlevel_create
      when :download
        return user.level >= @board&.minlevel_download
      else
        flash[:notice] = "Unknown action: #{action}"
        raise flash[:notice]
      end 
      
      false 
    end 
    
    #def nouser_can_advance?(action) 
    #  return false unless @board || @board_group
    def guest_can_advance?(action) 
      return false if @board.nil? && @board_group.nil?
    
      case action 
      when :index 
        return @board&.minlevel_index == 0 || !@board_group.nil?
      when :show 
        return @board&.minlevel_show == 0
      when :create 
        return @board&.minlevel_create == 0
      when :download
        return @board&.minlevel_download == 0
      else
        flash[:notice] = "Unknown action: #{action}"
        raise flash[:notice]
      end 
      
      false 
    end 
    
    def perm_denied_for(action) 
      #msgmap = { index:'목록 보기', show: '게시글 읽기', create: '게시글 작성/편집', download: '다운로드' }
      msgmap = { 
        index: t("hcafe2.post.perm_index"),
        show: t("hcafe2.post.perm_show"), 
        create: t("hcafe2.post.perm_create"), 
        download: t("hcafe2.post.perm_download") 
      }      

      user = cached_current_user 
      
      has_perm = false 
      
      if !user.nil? # 로그인한 사용자 
        has_perm = user.cached_has_role?(:superadmin) || 
          user.cached_has_role?(:admin) || 
          user.has_role?(:moderator, @board) ||
          user_can_advance?(user, action) 
      else # 로그인 안한 사용자 
        has_perm = guest_can_advance?(action) 
      end
      
      unless has_perm
        flash[:notice] = t('hcafe2.post.no_permission')
        redirect_to action: :perm_denied, msg: t('hcafe2.post.no_permission2', perm: msgmap[action])
        return true
      end
      
      false 
    end 
    
    def check_if_bot_request
      request&.env["HTTP_USER_AGENT"]&.match(/\(.*https?:\/\/.*\)/)    
    end 
    
    def encourage_login?
      maxread = ENV['MAX_READ_WITHOUT_LOGIN'].to_i || 0
      
      return false if maxread == 0
      
      left_hit = maxread - @total_hit
      
      if left_hit <= 0 && Random.new.rand(1..3) == 1
        redirect_to new_user_session_path(), notice: t('hcafe2.post.encourage_login_msg')
        return true
      end
      
      if left_hit >= 0 && left_hit <= 3
        flash[:success] = t('hcafe2.post.notice_to_be_redirected_to_login', count: left_hit)
      end
      return false
    end    
end

