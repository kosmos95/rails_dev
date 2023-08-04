# frozen_string_literal: true

class Auth::RegistrationsController < Devise::RegistrationsController

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  #before_action :check_recaptcha_enabled, only: [:new, :edit, :update, :create]

  # 권한 체크 해제 
  #skip_load_and_authorize_resource

  # GET /resource/sign_up
  # def new
  #   super
  # end

  #POST /resource
  def create

    if @recaptcha_enabled
      # v2 checkbox 
      recaptcha_valid = verify_recaptcha(model: resource)
      if !recaptcha_valid
        redirect_to new_user_registration_path, notice: t("hcafe2.post.captcha_check_failed")
        return 
      end
    end
    
    super

    # 계정 생성 성공... 했으면.     
    if resource.persisted?
      # 로그 저장
      UserLog.create_log(request, resource.id, true, :register, "회원가입 하였습니다.")
      
      # 회원가입 포인드 지급 
      User.send_point_by_admin(resource.id, PointLog::points_for_acton(:register), "회원가입에 대한 포인트")
    end
    
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end
  
  # DELETE /resource
  def destroy

    if resource.has_role?(:superadmin)
      set_flash_message :notice, :superadmin_cannot_be_destroyed
      return 
    end

    # super 원래 super 호출하지 않음. soft_delete 
    
    resource.soft_delete

    # 로그 저장
    UserLog.create_log(request, resource.id, true, :unregister, "계정 삭제 하였습니다.")
    
    # 회원가입 포인드 지급 
    User.send_point_by_admin(resource.id, PointLog::points_for_acton(:unregister), "회원탈퇴에 대한 포인트")

    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed
    
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
    
  end  

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end
  
  def check_nick_uniq 
    nick = params[:nick]
    
    user = User.find_by(nick: nick)
    
    respond_to do |format|
      format.json { 
        render json: { exists: !user.nil? },
        status: :ok
      }
    end
  end
  
  # # GET users_auth_register_info1
  # def register_info1
    # # show
    # @user = current_user 
    
    # render 'devise/registrations/register_info1'
  # end 
  
  # # GET users_auth_register_info1
  # def register_info1_update
    # # show
    
    # @user = current_user 
    # @userdata = @user.data
    
    # respond_to do |format|
      # if @userdata.update!(profile_params) 
        # format.html { redirect_to profile_info_path, notice: '회원정보가 수정되었습니다.' }
      # else
        # @user = current_user 
        # @userdata = @user.data
      # end
    # end
    
  # end 
  

  protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:nick, :name])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:nick], except: [:name]) 
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
    
  private 
  
    def check_recaptcha_enabled 
      if Rails.env != 'development' && (request.remote_ip =~ /^(127\.0\.|192\.168\.)/).nil? 
        @recaptcha_enabled = true 
      else 
        @recaptcha_enabled = false 
      end 
    end 
    
end
