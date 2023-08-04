require 'securerandom'

class Admin::UsersController < Admin::AdminController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    
    do_index_actions() 
      
    #@users = User.all
    
  end


  # POST /admin/process
  # POST /admin/process.json
  def proc
  
    selected = params[:selected_users]
    act = params[:act]
    target_board_id = params[:target_board_id]
    target_category = params[:target_category]
    now = Time.current
    
    case act
    when 'multi_set_confirmed'
      users = User.where('id in (?)', selected)
      users.each { |u| u.set_confirmed if u.id != 1 } 
      redirect_back fallback_location: admin_users_path, notice: '인증처리 되었습니다. '
    when 'multi_set_unconfirmed'
      users = User.where('id in (?)', selected)
      users.each { |u| u.set_unconfirmed if u.id != 1 }
      redirect_back fallback_location: admin_users_path, notice: '인증해제처리 되었습니다. '
    when 'multi_delete'
      users = User.where('id in (?)', selected)
      users.each { |u| u.soft_delete if u.id != 1} 
      redirect_back fallback_location: admin_users_path, notice: '탈퇴처리 되었습니다. '
    when 'multi_delete_undo'
      users = User.where('id in (?)', selected)
      users.each { |u| u.soft_delete_undo } 
      redirect_back fallback_location: admin_users_path, notice: '탈퇴해제처리 되었습니다. '    
    when 'multi_delete_hard'
      users = User.where('id in (?)', selected)
      users.each { |u| u.delete if u.id != 1 }  #1번 사용자는 삭제 안됨. 
      redirect_back fallback_location: admin_users_path, notice: '회원 데이타 삭제되었습니다. '      
    when 'multi_set_stopped'
      User.where('id in (?)', selected).update_all(stopped: true, stopped_at: now)
      redirect_back fallback_location: admin_users_path, notice: '정지처리 되었습니다.'      
    when 'multi_unset_stopped'
      User.where('id in (?)', selected).update_all(stopped: false, stopped_at: now)
      redirect_back fallback_location: admin_users_path, notice: '정지해제 되었습니다.'
    when 'multi_exclude_autoupgrade'
      User.where('id in (?)', selected).update_all(exclude_autoupgrade: true)
      redirect_back fallback_location: admin_users_path, notice: '자동레벨업 제외되었습니다..'
    when 'multi_exclude_autoupgrade_redo'
      User.where('id in (?)', selected).update_all(exclude_autoupgrade: false)
      redirect_back fallback_location: admin_users_path, notice: '자동레벨업 재개되었습니다..'      
    else
      puts "unprocessed: " + act 
    end
    
  end 
  
  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.password = SecureRandom.hex(8)

    respond_to do |format|
      if @user.save
        format.html { redirect_to url:[:admin, @user], notice: 'user was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    # unless can? :update, User
    #   flash[:error] = "사용자 변경 권한이 없습니다."
    #   return 
    # end

    #authorize! :read, @user 

    respond_to do |format|
      if @user.update(user_params) && 
        @user.set_roles_by_name(fixed_roles_by_user_auth(@user, params[:roles])) 
      then 
        format.html { redirect_to url: [:admin, @user], notice: 'user was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: 'user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :level, :nick, :user_group_id)
    end

    def fixed_roles_by_user_auth(target_user, role_arr)
      role_arr ||= []
      role_arr = role_arr.map &:to_sym
      
      # curr_user가 superadmin권한이 없으면 superadmin 권한 편집 허용안함 
      if !current_user.has_role? :superadmin 
        if role_arr.include?(:superadmin) && !target_user.has_role?(:superadmin) # superadmin 권한이 없으면 
          role_arr -= [ :superadmin ] # superadmin 권한 삭제 
        end 
      end 

      # curr_user가 admin 권한이 없으면 superadmin 권한 편집 허용안함 
      if !current_user.has_role? :admin 
        if role_arr.include?(:admin) && !target_user.has_role?(:admin) # admin 권한이 없으면 
          role_arr -= [ :admin ] # superadmin 권한 
        end 
      end

      # if role_arr.include?(:moderator) && !user.has_role?(:moderator)
        # role_arr -= [ :moderator ]
      # end

      # 1번 superadmin 인데, role_arr에 없으면 다시 추가 
      if target_user.id == 1 && !role_arr.include?(:superadmin) 
        role_arr += [ :superadmin ]
      end 
      
      role_arr
    end 
    
    def do_index_actions 

      @recnum = params[:recnum].present? ? params[:recnum].to_i : 15 
      @where = params[:where] || 'name'
      @page = params[:page].present? ? params[:page].to_i : 1
      @keyword = params[:keyword] || ''
      @sort = params[:sort] || "id"
      @orderby = params[:orderby] || "desc"
      @with_deleted = (params[:with_deleted].to_i || 0) > 0
      
      where_list = %w(name nick email level)
      
      where_str = "1 "
      #where_str += "AND (board_id = #{@board_id}) " if @board_id != ''

      where1 = where_list.include?(params[:where]) ? params[:where] : 'name'
      where_str += "AND (#{where1} like '%#{@keyword}%') " if @keyword != ''
      where_str += "AND (deleted_at is null) " if !@with_deleted
      
      @total_count = User.where(where_str).count 
      @total_page_num = @total_count / @recnum + 1 
      @users = User.where("#{where_str} ").order("#{@sort} #{@orderby}")
        .paginate(:page => params[:page], :per_page => @recnum, :total_entries => @total_count)
        
    end 

end
