# frozen_string_literal: true

class Auth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # 권한 체크 해제 
  #skip_load_and_authorize_resource

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
  
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        
        @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
        
        if @user 
        
          if @user&.persisted?
            sign_in_and_redirect @user, event: :authentication

            session[:user_id] = @user.id
            session[:roleinfo] = @user.make_roles_info_arr 
            session[:user] = @user 
        
            set_flash_message(:notice, :success, kind: "#{provider}".camelcase) if is_navigational_format?
        
          else
            session["devise.#{provider}_data"] = request.env["omniauth.auth"]
            set_flash_message(:notice, :fail, kind: "#{provider}".camelcase) if is_navigational_format?
            redirect_to new_user_registration_url
          end
          
        else 
          logger.error "cannot find/create user..."
        end
        
      end
    }
  end
  
  [:facebook, 
   :google_oauth2, 
   #:kakao
  ].each do |provider|
    provides_callback_for provider
  end
  
  # provider별로 서로 다른 로그인 경로 설정

  def after_sign_in_path_for(resource)
    auth = request.env['omniauth.auth']
    @identity = Identity.find_for_oauth(auth)
    @user = User.find(current_user.id)
    
    if @user&.persisted?
	
      set_flash_message :notice, :signed_in
      
      # 로그 저장
      UserLog.create_log(request, cached_current_user.id, true, :login, "로그인 하였습니다. (SNS:#{auth.provider})")

      # 회원가입 포인드 지급 
      User.send_point_by_admin(resource.id, PointLog::points_for_acton(:login), "로그인에 대한 포인트")

      # if @identity.provider == "kakao"
        # register_info2_path
      # else
        # register_info1_path
      # end
  
      root_path 
      
    else
    
      set_flash_message :notice, :signed_up
	
      # 로그 저장
      UserLog.create_log(request, resource.id, true, :register, "회원가입 하였습니다. (SNS:#{auth.provider})")

      # 회원가입 포인드 지급 
      User.send_point_by_admin(resource.id, PointLog::points_for_acton(:register), "회원가입에 대한 포인트")
	
      #visitor_main_path
      
      #return users_auth_register_info1_path 
    
      profile_info_edit_path    
      
    end

  end
  
  protected

    # def after_omniauth_failure_path_for(scope)
      # super(scope)
      
      # set_flash_message :notice, :signin_failed 
    # end  

end
