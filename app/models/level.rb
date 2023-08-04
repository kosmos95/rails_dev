class Level < ApplicationRecord
  
  MAX_LEVEL = 30 

  def self.user_count_of_level(level)
    User.where("level = ?", level).count 
  end 
  
  def self.of_level(level)
    Level.where('level = ?', level).first 
  end 
  
  def users_count
    Level.user_count_of_level(level)
  end 
  
  def self.check_if_autoupgrade_enabled?(current_level)
    level_data = Level.where('level = ?', current_level).first
    level_data.autoupgrade_enabled?
  end
  
  def autoupgrade_enabled?
    return false if self.level >= Level::MAX_LEVEL
    self.enable_autoupgrade
  end 
  
  def self.upgradable?(current_level, testdata = { login_num: 0, post_num: 0, comment_num: 0, visit_days: 0})
    
    level_data = Level.where('level = ?', current_level).first
    
    return false if level_data.nil? 
    
    return check_upgrade_value(level_data.autoupgrade_login_num, testdata[:login_num]) && 
      check_upgrade_value(level_data.autoupgrade_post_num, testdata[:post_num]) && 
      check_upgrade_value(level_data.autoupgrade_comment_num, testdata[:comment_num]) &&
      check_upgrade_value(level_data.autoupgrade_visit_days, testdata[:visit_days])
  end 
  
  def self.init_levels(site = nil, max_levels = Level::MAX_LEVEL) 
    (1..max_levels).each do |x| 
      lv = Level.create(site_id: site, level: x, name: "레벨#{x}", 
        enable_autoupgrade: false, 
        autoupgrade_login_num: 0, autoupgrade_post_num: 0, autoupgrade_comment_num: 0, autoupgrade_visit_days: 0, )
    end 
  end 
    
  private 
  
    def self.check_upgrade_value(lvl_data_cutline, value) 
      return true if lvl_data_cutline.nil? || lvl_data_cutline == 0
      
      value ||= 0
      
      lvl_data_cutline <= value
    end 
  
  
end
