class AdminController < ApplicationController
  def index
    redirect_to admin_dashboard_index_path 
  end 
end
