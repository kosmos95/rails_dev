class User < ApplicationRecord

  SUPERADMIN_ID = 1 

  has_one :user_datum
  
  has_many :user_logs 
  
  has_many :point_logs 
  
  has_many :identities, :dependent => :destroy
  
  belongs_to :user_group, optional: true
  
  ROLES = %i{ moderator admin superadmin }
  ADMIN_ROLES = %i{ admin superadmin }
  
  validates :nick, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, length: { in: 8..20 }, if: -> { !password.nil? && password != "" } 
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable,
         :registerable, :confirmable,
         :confirmable, :lockable, :timeoutable, :trackable
         
  devise :omniauthable, omniauth_providers: [
        :facebook,
        :google_oauth2,
        #:kakao
        ]
  
  before_save :default_values
  
  after_save :after_save
  after_destroy :after_destroy

  resourcify

  rolify
  
  
  def self.find_for_oauth(auth, signed_in_resource = nil)

    # user와 identity가 nil이 아니라면 받는다
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user

    # 해당 sns로 가입이 안되었으면. 
	
    if user.nil?
    
      # 이미 있는 이메일인지 확인한다.
      email = auth.info.email
      user = User.where(:email => email).first
      name = auth.name

      # 다른 sns로도 가입이 안되어 있으면 
      if user.nil?
        # 카카오는 email을 제공하지 않음

        if auth.provider == "kakao"
          # provider(회사)별로 데이터를 제공해주는 hash의 이름이 다릅니다.
          # 각각의 omnaiuth별로 auth hash가 어떤 경로로, 어떤 이름으로 제공되는지 확인하고 설정해주세요.
          user = User.new(
            name: name,
            nick: make_nick_from_name(name),
            #profile_img: auth.info.image,
            # 이 부분은 AWS S3와 연동할 때 프로필 이미지를 저장하기 위해 필요한 부분입니다.

            # remote_profile_img_url: auth.info.image.gsub('http://','https://'),
            password: Devise.friendly_token[0,20]
          )
          user.save!

        else
          user = User.new(
            email: email,
            name: name,
            nick: make_nick_from_name(name),
            
            #profile_img: auth.info.image,
            # remote_profile_img_url: auth.info.image.gsub('http://','https://'),

            password: Devise.friendly_token[0,20]
          )
          
          user.confirmed_at = Time.current 
          user.save!
        end
        
        if auth.info.image then 
          data = user.data
          data.avatar = auth.info.image
          data.save!
        end 
      end
      
    end

    if !user.nil? && identity.user_id != user.id
      begin 
        identity.user_id = user.id
        identity.save!
      rescue ActiveRecord::RecordNotUnique => e 
        #return nil
      end
    end

    user
  end

  # def self.new_with_session(params, session)
    # super.tap do |user|
      # if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        # user.email = data["email"] if user.email.blank?
      # end
    # end
  # end


  # email이 없어도 가입이 되도록 설정
  def email_required?
    true 
    #false
  end
  
  def self.cached_user(user_id)
    Rails.cache.fetch("users/#{user_id}", expires_in: 12.hours) do
      User.find(user_id)
    end
  end
  
  def self.superadmin_id 
    self::SUPERADMIN_ID
  end 
  
  # instead of deleting, indicate the user requested a delete & timestamp it  
  def soft_delete  
    update_attribute(:deleted_at, Time.current)  
  end
  
  def soft_delete_undo
    update_attribute(:deleted_at, nil)
  end
  
  # ensure user account is active  
  def active_for_authentication?  
    super && !deleted_at  
  end  
  
  # provide a custom message for a deleted account   
  def inactive_message   
    !deleted_at ? super : :deleted_account  
  end  

  #attr_accessible :roles
  
  def default_values
    self.level ||= 1 
    self.name ||= ""
    self.user_group_id ||= (UserGroup.first&.id || 1)
  end
  
  def data 
    self.user_datum || 
      UserDatum.create(user_id:self.id, point:0)
  end
  
  def make_roles_info_arr
    {
      :is_superadmin => superadmin?,
      :is_admin => admin?,
      :is_admin_group => admin_group?,
      :is_moderator_group => moderator_group?,
      :is_board_moderator => board_moderator?,
      :has_moderating_boards => has_moderating_boards?,
      :moderating_boards => moderating_boards,
    }
  end

  def guest? 
    self.id.nil?
  end 
  
  def superadmin?(cached = true)
    if cached 
      Rails.cache.fetch("user/#{self.cache_key}#role/superadmin?", expires_in:10.minutes) { superadmin?(false) }
    else  
      has_role?(:superadmin)
    end 
  end
  
  def admin?(cached = true) 
    if cached 
      Rails.cache.fetch("user/#{self.cache_key}#role/admin?", expires_in:10.minutes) { admin?(false) }
    else 
      has_role?(:admin)
    end 
  end 
  
  def admin_group? 
    superadmin? || admin? 
  end 
  
  def moderator_group? 
    board_moderator? || user_moderator?
  end 
  
  def board_moderator?(cached = true) 
    if cached 
      Rails.cache.fetch("user/#{self.cache_key}#role/board_moderator?", expires_in:10.minute) { 
        board_moderator?(false) 
      }
    else 
      has_role? :moderator, Board 
    end 
  end
  
  def has_moderating_boards?(cached = true) 
    if cached 
      Rails.cache.fetch("user/#{self.cache_key}#role/has_moderating_boards?", expires_in:10.minute) { 
        return has_moderating_boards?(false) 
      }
    else
      return false if self.id.nil?        
      return Board.with_role(:moderator, self).length > 0        
    end 
  end
  
  def moderating_boards(cached = true) 
    if cached 
      Rails.cache.fetch("user/#{self.cache_key}#role/moderating_boards", expires_in:10.minute) { 
        return moderating_boards(false) 
      }
    else
      return Board.with_role(:moderator, self) unless self.id.nil? 
    end
    []
  end
  
  def user_moderator?(cached = true)
    if cached 
      Rails.cache.fetch("user/#{self.cache_key}#role/user_moderator?", expires_in:10.minute) { 
        user_moderator?(false) 
      }
    else 
      has_role? :moderator, User 
    end
  end
  
  def cached_has_role?(name, obj = nil)
    Rails.cache.fetch("users/#{self.cache_key}#role/#{name.to_s}/#{obj.to_s}", expires_in:10.minute) do
      has_role? name, obj
    end 
  end
  
  def role_names_humanized
    r = []
    r.push "최고관리자" if superadmin? 
    r.push "관리자" if admin?
    Board.board_ids_of_my_moderating(self).map { |board_id| 
      b = Board.find(board_id)
      rname = "게시판관리자"
      rname += !empty(b.bid) ? "(#{b.bid})" : "(전체)"
      r.push rname
    }
    r
  end
  
  # def roles_name_humanize
    # str = "" 
    # str += (superadmin? ? "- 최고관리자": "") + "\n"
    # str += (admin? ? "- 관리자" : "") + "\n"
    # str += Board.board_ids_of_my_moderating(self).map { |board_id| 
      # b = Board.find(board_id)
      # link_str = "#{b.name} (bid: #{b.bid})"
      # "- 게시판 관리자: " + link_str
    # }.join("\n").to_s 
    # str += "\n"
    # str
  # end

  def signed_in? 
    !self.id.nil? 
  end 
  
  def confirmed? 
    !self.confirmed_at.nil?
  end
  
  def set_confirmed
	self.confirmed_at = Time.current 
	self.save
  end 
  
  def set_unconfirmed
	self.confirmed_at = nil 
	self.save
  end 

  #roles_arr 
  def set_roles_by_name(roles_arr)  
    #pp "roles arr: #{roles_arr}"
    roles_arr ||= [] 
    roles_arr.map! &:to_sym

    ADMIN_ROLES.each { |r| 
      if roles_arr.include?(r)
        #pp "add_role: #{r}"
        self.add_role(r)
      else 
        #pp "remove_role: #{r}"
        self.remove_role(r)
      end
    }
    
    expire_cache 
    
    true 
  end 
  
  # def roles=(roles)
    # roles = [*roles].map { |r| r.to_sym }
    # self.roles_mask = (roles & ROLES).map { |r| 2 ** ROLES.index(r) }.inject(0, :+)
  # end

  # def roles
    # ROLES.reject do |r|
      # ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    # end
  # end
  
  # def roles_humanize 
    # roles.map { |x| x.to_s }.join(", ")
  # end

  # def has_role?(role)
    # roles.include?(role)
  # end

  # def role?(base_role)
    # ROLES.index(base_role.to_s) <= ROLES.index(role)
  # end

  def level_upgradable?
    testdata = { 
      login_cnt: data.lvl_login_cnt , 
      post_cnt: data.lvl_post_cnt, 
      comment_cnt: data.lvl_comment_cnt, 
      visit_days: data.lvl_visit_days,
    }
    
    Level.check_if_autoupgrade_enabled?(level) && Level.upgradable?(level, testdata)
  end 
  
  def level_upgrade_if_can 
    return if self.level >= Level::MAX_LEVEL 
    
    if level_upgradable?
      self.level += 1 
      self.save 
      
      data.reset_level_upgrade_values 
      data.save 
      
      # 로그 저장
      UserLog.create_log_simple(self.id, true, :login, "레벨업 하였습니다. 새 레벨: #{level}")
      
      return true 
    end 
    
    false
  end 
  
  # class TrackSessionsController < Devise::SessionsController
    # after_filter :after_login, :only => :create

    # def after_login
      # Visit.create!(user_id: current_user.id, user_ip: current_user.current_sign_in_ip, user_email: current_user.email)
    # end
  # end

  # def logins_per_day(user_id)
    # dates_visited = Visit.where(user_id: user_id).select('distinct created_at').all.collect{|x| x[:created_at].to_date}
    # puts "************* USER ID #{user_id} *************"
    # dates_visited.group_by {|date| date}.map {|date_visited, times_visited| puts "Date Visited: #{date_visited} Times Visited: #{times_visited.count}"}
  # end
  
  def self.send_point_by_admin(to_user_id, point, desc)

    to_user = User.find(to_user_id)
    raise "unknown user" if to_user.nil?
    
    to_user.data.point += point 
    to_user.data.save 
    
    PointLog.create_log_admin(to_user_id, point, desc)
    
  end 
  
  def self.send_point(to_user_id, from_user_id, point, desc)

    to_user = User.find(to_user_id)
    raise "unknown user" if to_user.nil?
    
    from_user = User.find(from_user_id)
    raise "unknown user" if from_user.nil?

    to_user.data.point += point 
    to_user.data.save 
    
    from_user.data.point += point 
    from_user.data.save 
    
    PointLog.create_log(to_user_id, from_user_id, point, desc)        
  end 
    
  # def self.serialize_from_session(key, salt)
    # single_key = key.is_a?(Array) ? key.first : key
    # user = Rails.cache.fetch("user:#{single_key}") do
       # User.where(:id => single_key).entries.first
    # end
    # # validate user against stored salt in the session
    # return user if user && user.authenticatable_salt == salt
    # # fallback to devise default method if user is blank or invalid
    # super
  # end
    
  def expire_cache 
    Rails.cache.delete("#{cache_key}")
    #Rails.cache.delete_matched(%r!#{cache_key}/?.*!)
  end 
  
  def connected_proviers
    identities.map do |id|
      id.provider
    end 
  end 
  
  private 
  
    def after_save
      expire_cache      
    end 
    
    def after_destroy
      expire_cache
    end 

    def self.make_nick_from_name(name)
      random_string = ('a'..'z').to_a.shuffle.first(8).join
      nick1 = name || "무명씨"
      while true
        u = self.find_by(nick: nick1)
        break if u.nil?
        nick1 = "#{name}-#{random_string}"
      end
      nick1
    end 
    
end
