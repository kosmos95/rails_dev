#require 'carrierwave/orm/activerecord'

class ProfileController < ApplicationController
  
  around_action :run_using_slave, only: [:info_show]
  
  # index와 show action을 제외한 모든 action은 로그인이 필요함
  before_action :authenticate_user!, except: []
  
  #validates :avatar, :file_size => { :maximum => 1.megabytes.to_i }   

  def info_show
    @user = current_user 
    @userdata = @user.data
  end
  
  def info_edit
    @user = current_user 
    @userdata = @user.data
  end 
  
  def info_update 
    @user = current_user 
    @userdata = @user.data
    
    respond_to do |format|
      if @user.update(profile_params_user) && @userdata.update(profile_params)
        #format.html { render :info_edit, notice: '회원정보가 수정되었습니다.' }
        format.html { redirect_to profile_info_path, notice: t('hcafe2.profile.modified') }
        #format.json { render :show, status: :ok, location: @post }
      else
        #@user = current_user 
        #@userdata = @user.data
      
        #format.html { render "posts/#{@skin}/edit" }
        #format.json { render json: @post.errors, status: :unprocessable_entity }
        
        format.html { render "profile/info_edit" }
        #format.json { render json: @userdata.errors, status: :unprocessable_entity }        
      end
    end
    
  end  
    
  def posts 
  end 

  def scraps
  end 
  
  def comments 
  end 
  
  def favorites 
  end 

  private 
  
    def profile_params_user
      params.require(:user_datum).permit(:name, :nick)
    end
    
    def profile_params
      params.require(:user_datum).permit(:name, :nick, :avatar, :remove_avatar, :note, :mailing)
    end
  
end
