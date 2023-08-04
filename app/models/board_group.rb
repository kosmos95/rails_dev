class BoardGroup < ApplicationRecord

  has_many :boards 

  after_create :after_create
  after_update :after_update 
  after_destroy :after_destroy
  
  resourcify
  
  def name_with_id 
    "#{name}(#{id})"
  end 
  
  def boards_for_display
    Board
      .where("board_group_id=? and display=1 and hidden=0", self.id)
      .order("arrange ASC, id ASC")
      .all
  end
  
  # def last_modified 
    # Rails.cache.fetch("board_groups/#{id}/last_modified") { nil }
  # end 
  
  private 
  
    def after_create 
      expire_cache
    end 
    
    def after_update
      expire_cache
    end
    
    def after_destroy
      expire_cache
    end
      
    def expire_cache
      delete_cache_if_exists("boards_group/#{id}")
      delete_cache_if_exists("boards_group/id/#{name}")
      delete_cache_if_exists("boards_group/#{name}/id")
    end
  
end
