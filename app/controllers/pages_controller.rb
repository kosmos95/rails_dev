class PagesController < ApplicationController
  include HighVoltage::StaticPage

  #before_action :authenticate_user!
  
  # 권한 체크 해제 
  #skip_load_and_authorize_resource

  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when 'home'
      'home'
    else
      default_layout
    end
  end

  def invalid_page 
    raise ActionController::RoutingError, "No such page: #{params[:id]}" 
    #_layout 'blank'
    #render 'pages/404', :status => 404, :layout=>'blank' 
  end
 
end
