class Board < ApplicationRecord

  belongs_to :board_group, :optional => true
  
  has_many :posts
  
  #has_many :users, through: :users_roles

  after_create :after_create
  after_update :after_update 
  after_destroy :after_destroy
  
  after_save :after_save 
  after_initialize :after_initialize 

  resourcify

  attr_accessor :board_managers 
  validate :board_managers_valid_user_email
  
  #######################################
  
  # Validations 
  # Post를 입력할 때 content를 반드시 입력해야 함 + 200자 제한
  validates :bid, length: { minimum: 2 } 
  validates :name, length: { minimum: 2 }
  validates :board_group_id, presence: true
  
  def post_count 
    posts.count 
  end 
  
  def post_group_change(board_group_id) 
    # posts.each do |p|
      # p.board_group_id = board_group_id
      # p.save
      # pi = p.post_index
      # pi.board_group_id = board_group_id
      # pi.save
    # end
    
    run_using_master do 
      query1 = "UPDATE `#{Post.table_name}` SET board_group_id=#{board_group_id} WHERE board_id = #{self.id}" 
      ActiveRecord::Base.connection.execute(query1)
      
      query2 = "UPDATE `#{PostIndex.table_name}` SET board_group_id=#{board_group_id} WHERE board_id = #{self.id}"
      ActiveRecord::Base.connection.execute(query2)
    end
    
  end 
  
  def moderator?(user)
    moderators.include?(user)
  end 
  
  def moderators(cached = true)
    if cached 
      Rails.cache.fetch("user_role/moderators/board/#{id}", expires_in: 10.minutes) do 
        moderators(false)
      end 
    else 
      users = User.with_role(:moderator, self).uniq
      users.select { |u| u.has_strict_role? :moderator, self } 
    end 
  end
  
  def self.general_moderators(cached = true) 
    if cached 
      Rails.cache.fetch("user_role/general_moderators/board", expires_in: 10.minutes) do 
        self.general_moderators(false) 
      end
    else
      User.with_role(:moderator, Board).uniq
    end 
  end 
  
  def self.board_ids_of_my_moderating(user, cached = true)
    if cached 
      Rails.cache.fetch("user_role/board_ids_of_my_moderating/user/#{user.id}", expires_in: 10.minutes) do 
        self.board_ids_of_my_moderating(user, false)
      end 
    else 
      roles = Board.find_roles(:moderator, user)
      board_id_arr = roles.map { |x| x.resource_id }.select { |x| !x.nil? }
    end 
  end 
  
  def self.cached_board(board_id)
    Rails.cache.fetch("boards/#{board_id}", expires_in: 10.minutes) do
      Board.find(board_id)
    end
  end
  
  def self.cached_board_by_bid(bid)
    Rails.cache.fetch("boards/bid/#{bid}", expires_in: 10.minutes) do
      Board.find_by(bid: bid)
    end
  end  
  
  def self.cached_board_by_name(board_name)
    Rails.cache.fetch("boards/name/#{board_name}", expires_in: 10.minutes) do
      Board.find_by(name: board_name)
    end
  end
  
  def self.cached_recent_posts_count(board_id, interval) 
    #interval == timestanp (int)
    Rails.cache.fetch("boards/id/#{board_id}/count/#{interval}", expires_in: 10.minutes) do
      self.recent_posts_count(board_id, interval)
    end
  end 
  
  def self.recent_posts_count(board_id, interval) 
    #interval == timestanp (int)     
    Post.where("board_id = ? and created_at >= ?", board_id, Time.now - interval).count 
  end 
  
  def expire_cache
    delete_cache_if_exists("boards/#{id}")
    delete_cache_if_exists("boards/bid/#{bid}")
    delete_cache_if_exists("boards/name/#{name}")
    delete_cache_if_exists("boards/#{name}/id")
  end

  # def set_last_modified_to_now
    # now = Time.now.utc
    # Rails.cache.write("boards/#{id}/last_modified", now)
    # Rails.cache.write("board_groups/#{board_group_id}/last_modified", now)
  # end 
  
  # def last_modified 
    # Rails.cache.fetch("boards/#{id}/last_modified") { nil }
  # end 
  
  # def moderators
    # users = []
    # board_roles = self.roles.select { |x| x.name == 'moderator' }      
    # board_roles.each { |r| 
      # users += r.users
    # }
    # users 
  # end   
  
  # after_create :after_create
  # after_destroy :after_destroy
  
  # def after_create
    # indie_bid = "#{self.bid}"
    
    # puts "creating post table: " + indie_bid
    # Post.create_indie_table(self.bid)
    
    # puts "creating comment table: " + indie_bid
    # Comment.create_indie_table(self.bid)
    
  # end 
  
  # def after_destroy 
    # indie_bid = "#{self.bid}"
    
    # puts "destorying post table: " + indie_bid
    # Comment.destroy_indie_table(indie_bid)
    
    # puts "destorying post table: " + indie_bid
    # Post.destroy_indie_table(indie_bid)    
  # end 
  
  private 
  
    # 게시판 최소 권한 설정 
    def after_create 
      self.minlevel_index = 0 if self.minlevel_index <= 0
      self.minlevel_show = 0 if self.minlevel_show <= 0
      self.minlevel_create = 1 if self.minlevel_create <= 0
      self.minlevel_download = 0 if self.minlevel_download <= 0
      self.save
      
      expire_cache
    end 
    
    def after_update
      expire_cache
    end
    
    def after_destroy
      puts "############# after destorying"
      expire_cache
      do_delete_work
    end
    
    def do_delete_work
      puts "############# do_delete_work"
      msg = "board delete"
      PostDeleterWorker.perform_at(3.seconds.from_now, msg, self.id)
    end
    
    def after_initialize
      @board_managers = self.moderators.map { |x| x.email }.join("\n")
    end 
    
    def after_save
      run_using_master do 
        do_board_role_actions
      end 
    end 
    
    def do_board_role_actions 
    
      logger.error "do_board_role_actions"
    
      @board_managers ||= ""
    
      emails = @board_managers.split("\n")
        .map { |x| x.strip }
        .filter { |x| x != "" }
        .uniq
      
      logger.error "emails: " + emails.to_s 
      logger.error "board self: " + self.bid 
      
      # 현재 관리자 목록에는 있지만, @board_managers 목록에서 없으면 삭제
      self.moderators.each { |user|
        if !emails.include?(user.email.strip)
          logger.error "remving moderator: " + user.email
          #user.remove_role :moderator, Board
          user.remove_role :moderator, self
        end
      }
      
      # 현재 관리자 목록에 없으면 새로 추가 
      emails.each { |email|
        user = User.where('email = ?', email).first 
        
        raise :no_user_for_email if user.nil?
        
        # if user && !user.has_role?(:moderator, Board) then 
          # user.add_role :moderator, Board 
        # end 

        if user && !user.has_strict_role?(:moderator, self) then 
          logger.error "adding: " + user.email
          user.add_role :moderator, self 
        end
      }
      
    end 
    
    def board_managers_valid_user_email 
    
      return if @board_managers.nil? 
      
      emails = @board_managers.split("\n").map { |x| x.strip }.uniq
      emails.each { |email|
        user = User.where('email = ?', email.strip).first 
        if user.nil?
          errors.add(:roles, :email_not_found, message: "존재하지 않는 이메일: #{email}")
        end 
      }
      
    end 
    
end
