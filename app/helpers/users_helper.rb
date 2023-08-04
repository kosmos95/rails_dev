module UsersHelper

  def cached_current_user    
    Rails.cache.delete("users/#{session[:user_id]}") if session[:user_id].nil?     
    Rails.cache.fetch("users/#{session[:user_id]}", :expires_in => 1.hours) { current_user }
  end
  
  def cached_user_signed_in? 
    !!cached_current_user
  end 

  def cached_user_session 
    cached_current_user && user_session 
  end 
  
  def current_user_id
    session[:user_id] || cached_current_user&.id 
  end
  
  alias_method :cached_current_user_id, :current_user_id 
  
end
  