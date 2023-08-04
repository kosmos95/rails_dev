class PointLog < ApplicationRecord
  
  DEFAULT_REGISTER_POINT = 1000
  DEFAULT_UNREGISTER_POINT = 0
  DEFAULT_LOGIN_POINT = 20
  DEFAULT_LOGOUT_POINT = 0
  DEFAULT_POST_POINT = 100
  DEFAULT_POST_DEL_POINT = -100
  DEFAULT_COMMENT_POINT = 20
  DEFAULT_COMMENT_DEL_POINT = -20
  
  belongs_to :user 
  
  def sender 
    User.find(self.by_user_id)
  end 
  
  def self.create_log_admin(user_id, point, reason)
    # 0 이면 기록하지 않음 
    return if point == 0
    
    PointLog.create(
      user_id: user_id, 
      by_user_id: User::superadmin_id,
      point: point, 
      reason: reason, 
    )
    
  end 
  
  def self.create_log(to_user_id, from_user_id, point, reason)
    # 0 이면 기록하지 않음 
    return if point == 0
    
    PointLog.create(
      user_id: to_user_id, 
      by_user_id: from_user_id,
      point: point, 
      reason: reason, 
    )
  end 
  
  def self.points_for_acton(action)
    const_name = "DEFAULT_#{action.to_s.upcase}_POINT"
    if self::const_defined? const_name 
      return self::const_get const_name
    else 
      raise "Unknown constant"
    end 
  end 
  
end
