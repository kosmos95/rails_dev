class UserDatum < ApplicationRecord

  LEVEL_UPGRADE_KEYS = [ :lvl_login_cnt, :lvl_post_cnt, :lvl_comment_cnt, :lvl_visit_days ]

  belongs_to :user, touch: true 
  
  mount_uploader :avatar, AvatarUploader

  #after_update :after_update 
  
  #def after_update
  #  self.user.save! 
  #end 
  
  def self.attr_user_accessor(*args)  
    args.each do |arg|
      arg1 = 'self.user.'+arg.to_s
      self.class_eval("def #{arg}; #{arg1}; end")
      self.class_eval("def #{arg}=(val); #{arg1}=val; end")
    end
  end

  attr_user_accessor :email, :name, :nick

  # total_post_cnt, total_cmt_cnt 
  def incr_count_value(key) 
    val = self.send(key) || 0
    self.send("#{key}=", val + 1)
  end 
  
  def reset_level_upgrade_values 
    LEVEL_UPGRADE_KEYS.each { |x|
      self.send("#{x}=", 0)
    }
  end 

  def incr_level_upgrade_value(key) 
    
    key = for_level_upgrade_key(key)
    
    val = self.send(key) || 0

    set_level_upgrade_value(key, val + 1)
  end 
  
  def set_level_upgrade_value(key, value, save_db = true)
    
    key = for_level_upgrade_key(key)

    self.send("#{key}=", value)
    
    save if save_db
  end 
  
  def set_level_upgrade_values(testvalues) 
    testvalues.each { |key| 
      set_level_upgrade_value(key, testvalues[key], false)
    }
    save 
  end 

  #def avatar_default_url 
  #  "/common/profile/avatar_default.png"
  #end 
  
  def self.avatar_default_url 
    "/common/profile/avatar_default.png"
  end 
  
  private 
    
    def for_level_upgrade_key(key)
      key = key.to_s if key.is_a? Symbol    
      key = 'lvl_' + key unless key =~ /^lvl_/
      key 
    end 
    
end
