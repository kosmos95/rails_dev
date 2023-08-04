#require 'timeout'

class Menu < ApplicationRecord
  
  #include CachedData 

  belongs_to :site
  validates :name, presence: true
  
  after_create :expire_cache
  after_update :expire_cache

  #@@data = Hash.new 
  #@@timeout = Hash.new 
  
  def self.load_yaml_menu(content)
    YAML::load(content)
  end 
  
  def self.get_menu(name)
    Rails.cache.fetch("menu/name/#{name}", expires_in: 10.minutes) do 
      menu = Menu.find_by(name: name)
      menu ? self.load_yaml_menu(menu.content) : nil 
    end
  end
  
  # def self.get_menu(name)
    # t = Time.now 
	
    # if @@data[name].nil? || @@timeout[name].nil? || @@timeout[name] < t 
      # menu = Menu.find_by(name: name)   
      # @@data[name] ||= self.load_yaml_menu(menu.content)
	  
      # # 최소 30초동안은 DB 읽지 메모리캐싱 
      # @@timeout[name] = t + 10 
    # end
    
  	# @@data[name]
  # end

  private 
  
    def expire_cache 
      Rails.cache.delete("menu/#{self.id}")
      Rails.cache.delete("menu/name/#{self.name}")
    end 

end
