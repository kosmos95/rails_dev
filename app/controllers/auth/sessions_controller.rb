# frozen_string_literal: true

class Auth::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # 권한 체크 해제 
  #skip_load_and_authorize_resource

#layout 'admin/admin'

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create  

    super

    session[:user_id] = current_user.id
    session[:roleinfo] = current_user.make_roles_info_arr 
    session[:user] = current_user 

    Throttling.for(:user_signin).check(:user_id, cached_current_user.id) do
      # Do your stuff here
      raise Exception.new "너무 자주 로그인을 시도 중입니다." 
      return 
    end
    
    cached_current_user.data.incr_level_upgrade_value(:login_cnt)
    cached_current_user.data.incr_level_upgrade_value(:visit_days) if is_morethan_1day_passed     
    
    if !cached_current_user.exclude_autoupgrade # 자동 레벨 업 제외가 아니면 
      if cached_current_user.level_upgrade_if_can 
        flash[:notice] = "회원레벨이 올라갔습니다. 감사합니다. 새 레벨: #{cached_current_user.level}"
      end 
    end 
    
    # 로그 저장
    UserLog.create_log(request, cached_current_user.id, true, :login, "로그인 하였습니다.")
    
    # 회원가입 포인드 지급 
    User.send_point_by_admin(resource.id, PointLog::points_for_acton(:login), "로그인에 대한 포인트")
    
  end
  
  # DELETE /resource/sign_out
  def destroy
  
  	raise "Current User == null" if cached_current_user.nil? 

    user_id = cached_current_user.id 
	    
    # 캐쉬 해제 
    cached_current_user.expire_cache 
    
    super
    
    session[:user_id] = nil 
    session[:roleinfo] = nil 
    session[:user] = nil 
    session[:post_view_cnt] = nil 
    #session[:post_view] = nil 
    
    # 로그 저장 
    UserLog.create_log(request, user_id, true, :logout, "로그아웃 하였습니다.")
    
    # 회원가입 포인드 지급 
    User.send_point_by_admin(user_id, PointLog::points_for_acton(:logout), "로그아웃에 대한 포인트")
    
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private 
  
    def is_morethan_1day_passed
      return false if cached_current_user.last_sign_in_at.nil? 
      return false if cached_current_user.current_sign_in_at.nil? 
      
      last = cached_current_user.last_sign_in_at
      now = cached_current_user.current_sign_in_at
      
      now >= last.advance(days: 1)
    end 
  
end
