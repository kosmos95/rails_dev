class Comment < ApplicationRecord
  
  self.primary_key = :id

  #GID_MAX = (1_000_000_000 - 1).to_f  + 0.99
  #GID_MAX = 0.00 
  
  # User/Post와 Comment의 1:N 관계
  belongs_to :post
  belongs_to :user
  
  has_many :comment_favors, dependent: :destroy
  
  mount_uploader :image, ImageUploader
  #has_one_attached :image
  
  before_create :before_create 
  after_create :after_create 
  #after_save :after_save
  before_destroy :before_destroy 
  after_destroy :after_destroy 

  # Comment의 content 글자수 제한
  validates :content, length: { maximum: 250, too_long: "댓글을 %{count}자 이내로 입력해주세요."}, presence: true 
  validate :check_image_file_size

  attr_accessor :reply #, :parent_depth #, :parent_id

  # def self.with(indie_bid) 
    # self.table_name = self.table_name_prefix + self.make_indie_table_name(indie_bid) # table_name_prefix + "comments_" + table_name
  # end 
  
  # def self.make_indie_table_name(indie_bid)
    # indie_bid.nil? ? "comments" : ("comments_" + indie_bid) 
  # end
  
  
  def depth 
    self.reply_order.length 
  end 
  
  def before_destroy
    image.remove!
    image.delete_empty_dirs 
  end
  
  alias_method :old_destroy, :destroy
  
  def destroy(*args)
    begin 
      rv = old_destroy(*args)
    rescue NoMethodError => e 
      logger.debug "NoMethodError: #{e}"
      puts e.backtrace
    #rescue ActiveRecord::RecordInvalid => e 
    #  logger.debug "ActiveRecord::RecordInvalid"
    end
    rv
  end 
  
  # def self.create_indie_table(indie_bid = nil)

    # table_name1 = make_indie_table_name(indie_bid)

    # ActiveRecord::Migration.class_eval do    

      # create_table table_name1, id: :integer, options: "ENGINE=MyISAM" do |t|

        # t.integer :gid 
        # t.integer :parent_id, null: false, default:0
        # t.string :reply_order, limit:20, null: false, default:""

        # t.string :name, limit:32, null: false, default:""
        # t.string :nick, limit:32, null: false, default:""
        # t.text :content
      
        # t.string :html, limit:4, null: false, default: "html"
        # t.string :ip, limit:25, null: false, default:''

        # t.belongs_to :user, index: true, type: :integer
        # t.belongs_to :post, index: true, type: :integer

        # t.integer :score1, null: false, default: 0
        # t.integer :score2, null: false, default: 0
        # t.integer :report_cnt, null: false, default: 0 #신고 
      
        # t.integer :deleted, limit:1, default:0 
        
        # t.index :gid 
        # t.index :deleted 

        # t.timestamps
      # end

    # end 
    
  # end 
  
  def count2 
    Comment.where('deleted = 0').count 
  end 
  
  def soft_delete 
    self.deleted = 1
  end 
  
  def soft_delete!
    soft_delete
    self.save
    
    after_destroy
  end
  
  def soft_deleted? 
    self.deleted == 1 
  end
  
  def children
    Comment.where('parent_id = ? and deleted = 0', self.id)
  end
  
  def check_image_file_size
    max_file_size = 2.megabytes
    size = (image&.file&.size).to_i
    if size > max_file_size
      errors.add(:image, "용량이 너무 큰 이미지는 올릴 수 없습니다. #{max_file_size.to_f/(1024*1024)}MB")
    end
  end

  private 
    
    def before_create 

      validates_presence_of :parent_id if self.reply.present? 
      
      if self.reply then

        if self.parent_id.nil?
          self.errors.add(:error, "더 이상 답글을 달 수 없습니다.")
          return false 
        end

        p = Comment.where(id: self.parent_id).first

        # gid_int = p.gid.to_i 
        # re_cnt = Comment.where("gid >= ? and gid < ?", gid_int, gid_int+1.0).count 
        # if re_cnt >= 98 then 
        #   self.errors.add("더 이상 댓글을 달 수 없습니다.")
        #   return false 
        # end

        #Comment.where("gid > ? and gid < ?", p.gid, gid_int+1.0).update_all('gid = gid + 0.01')

        # ActiveRecord::Base.connection.execute(
            # "update `#{Comment.table_name}` set gid2 = if(CAST(gid AS UNSIGNED) < gid, 
                   # CAST(gid AS UNSIGNED) + 1.00 - (gid - CAST(gid AS UNSIGNED)), 
                   # gid)")

        self.gid = p.gid # @parent_id; #p.gid + 0.01 
        self.reply_order = next_reply_str(p)

      else 
        self.gid = 0 ## 저장된 후에 생성되는 id값으로 gid 값이 설정되어야 함. 
        self.reply_order = next_reply_str(nil)
      end 
      
    rescue Exception => e 
      self.errors.add(:error, e.message)
      return false 
    end
          
    def next_reply_str(comment)

      return "" if comment.nil? 

      raise Exception.new("Internal error: gid 값이 0일 수 없습니다.") if comment.gid == 0 

      reply_len = comment.reply_order ? comment.reply_order.length + 1 : 1
      results = ActiveRecord::Base.connection.execute( 
            "select MAX(SUBSTRING(reply_order, #{reply_len}, 1)) as reply 
                from `#{Comment.table_name}`
                where SUBSTRING(reply_order, #{reply_len}, 1) <> ''
                    and gid = '#{comment.gid}' 
                    and reply_order like '#{comment.reply_order}%'"
            )
    
      reply_char = 'A'
      
      if results.present? then
        reply = results.first[0]
        raise Exception.new("26개까지 댓글을 달 수 있습니다.") if !reply.nil? && reply.ord >= 'Z'.ord 
        reply_char = (reply.ord + 1).chr unless reply.nil?
      end
      
      reply_str = comment.reply_order.to_s + reply_char.to_s
    end 
    
    def after_create 
      
      #after_create_reload_data
    
      if self.user_id
        userdata = self.user.data
        userdata.total_cmt_cnt += 1
        userdata.save! 
        
        # 게시물 작성 포인드 지급 
        User.send_point_by_admin(self.user_id, PointLog::points_for_acton(:comment), "댓글 작성에 대한 포인트")
      end
    end 
    
    # def after_create_reload_data
      # self.class.connection.clear_query_cache
      # fresh_comment = self.class.unscoped {
        # self.class.find_by!(board_id: board_id, post_id: post_id, created_at: created_at)
      # }
      # @attributes = fresh_comment.instance_variable_get('@attributes')
      # @new_record = false
    # end 
    
    def after_destroy 
      comment_cnt = Comment.where('post_id = ? and deleted = 0', self.post_id).count
      post.comment_cnt = comment_cnt
      post.save
      
      if self.user_id
        userdata = self.user.data
        userdata.total_cmt_cnt -= 1
        userdata.save!
        
        # 게시물 작성 포인드 지급
        User.send_point_by_admin(self.user_id, PointLog::points_for_acton(:comment_del), "댓글 삭제에 대한 포인트")
      end
    end 
	
end
