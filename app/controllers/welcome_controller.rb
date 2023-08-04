class WelcomeController < ApplicationController

  around_action :run_using_slave, only: [:index]
  
  # 권한 체크 해제 
  #skip_load_and_authorize_resource

  def index
    #@recent_posts  = Post.where('hidden=0').order('gid').limit(7)
    @recent_post_indices  = Post.where('hidden=0').order('gid').limit(7)
    
    render frontpage
  end 

  private 
    
    def frontpage 
      #(!mobile? || session[:pcmode]) ? 'index' : 'index_m'
      !mobilemode? ? 'index' : 'index_m'
    end 
    
end
