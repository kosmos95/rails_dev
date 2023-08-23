class ApplicationController < ActionController::Base

  include FunctionsHelper
  include ApplicationHelper
  include SitesHelper
  include UsersHelper
  include MultidbHelper 

  # cancancan으로 posts의 authorization을 처리하겠다는 의미
  #load_and_authorize_resource
  
  layout :default_layout
  
  before_action :check_pcmode_params, :check_darkmode_params, :load_menus
  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html {         
        if request.url =~ /^admin/
          redirect_back(fallback_location: admin_dashboard_index_path, :alert => exception.message)
        else 
          redirect_back(fallback_location: root_path, :alert => exception.message)
        end
      }
    end
  end
  
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    #sign_out_user # Example method that will destroy the user cookies
  end
  
  #rescue_from Mysql2::Error do |e| 
  #  flash[:error] = e.to_s 
  #  redirect_to root_path 
  #end 
  
  before_action do
    if cached_current_user&.superadmin?
      Rack::MiniProfiler.authorize_request
    end
  end
  
  #around_action :logging_traffic

  #etag { cached_current_user.try :id }
  
  # before_action :configure_permitted_parameters, if: :devise_controller?

  # protected
  #   def configure_permitted_parameters
  #     devise_parameter_sanitizer.for(:sign_up)  { |u| u.permit(  :email, :password, :password_confirmation, roles: [] ) }
  #   end

  def default_layout 
    if request.url =~ /^admin/ 
      return 'admin/admin'
	  
    else
      #return 'hcafe2/mobile' if request.host =~ /^m\./
      #return 'hcafe2/application' if Rails.env == :production 
      return pcmode? ? 
        'hcafe2/application' :
        'hcafe2/mobile'
    end
  end 
  
  # def pcmode 
    # if session[:pcmode].nil? then; 
      # !mobile? 
    # else 
      # session[:pcmode]
    # end   
  # end 
  
  #def error_layout 
  #  'blank'
  #end 
  
  def toggle_pcmode
    if session[:pcmode].nil? then 
      session[:pcmode] = true 
    else 
      session[:pcmode] = !session[:pcmode] 
    end 

    session[:pcmode_changed] = true
    redirect_back(fallback_location: root_path)      
  end 
  
  def set_pcmode(pcmode) 
    session[:pcmode] = pcmode 
    session[:pcmode_changed] = true
    
    redirect_back(fallback_location: root_path)
  end 
  
  def toggle_darkmode
    if session[:darkmode].nil? then 
      session[:darkmode] = false 
    else 
      session[:darkmode] = !session[:darkmode] 
    end 

    session[:darkmode_changed] = true
    redirect_back(fallback_location: root_path)      
  end 
  
  def set_darkmode(darkmode) 
    session[:darkmode] = (darkmode == 'dark' || darkmode == '1') ? true : false 
    session[:darkmode_changed] = true
    
    redirect_back(fallback_location: root_path)
  end   
  
  def image_url_fix_in_html(content) 
    return content if Rails.env == "development"
    content.gsub(%r{<img\s+src\s*=\s*['"](.*)['"]}im, "<img src=\"#{image_url_base}\\1\"")
  end 
  
  def image_url_fix(url) 
    return url if Rails.env == "development"
    if url =~ %r{^/} 
      "#{image_url_base}#{url}"
    else 
      url 
    end 
  end 
    
  protected
    
    # def after_sign_in_path_for(resource)
      # sign_in_url = new_user_session_url
      # if request.referer == sign_in_url
        # super
      # else
        # stored_location_for(resource) || request.referer || root_path
      # end
    # end
    
    def check_pcmode_params
      if session[:pcmode_changed] 
        session[:pcmode_changed] = false
        params.delete(:pcmode) 
        return 
      end 
      
      unless params[:pcmode].nil? 
        case params[:pcmode] 
        when "pc"
          set_pcmode(true)
        when "mobile"
          set_pcmode(false)
        when "toggle"
          toogle_pcmode
        end 
      end
      
      if session[:pcmode].nil? && mobile_host? then 
        set_pcmode(false)
      end
    end
    
    def check_darkmode_params
      if session[:darkmode_changed] 
        session[:darkmode_changed] = false
        params.delete(:darkmode) 
        return 
      end 
      
      unless params[:darkmode].nil? 
        set_darkmode(params[:darkmode])
      end
      
      if session[:darkmode].nil? then 
        set_darkmode(false)
      end
    end 

    def current_url(overwrite={})
      url_for :only_path => false, :params => params.merge(overwrite)
    end
    
    def logging_traffic 
      path = url_for :only_path => true 
      begin 
        yield 
      ensure 
        logger.warn "#{path} - #{response.status} - #{request.headers['HTTP_REFERER']} - #{request.headers['HTTP_USER_AGENT']}"
      end 
    end 


  private
    def load_menus
     @menus = NewMenu.all
    end

end
