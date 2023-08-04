class UserLog < ApplicationRecord
  
  belongs_to :user 
  
  def self.create_log_simple(user_id, success=true, event_name, reason)
    UserLog.create(
      user_id: user_id, 
      event_name: event_name, 
      reason: reason, 
      ip: nil,
      useragent: nil,
      url: nil, 
      referer: nil
    )
  end 
  
  def self.create_log(request, user_id, success=true, event_name, reason)
    UserLog.create(
      user_id: user_id, 
      event_name: event_name, 
      reason: reason, 
      ip: request.remote_ip, 
      useragent: request.user_agent[0..90] + "...", 
      url: nil,
      referer: nil 
    )
  end 
  
end
