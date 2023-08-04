class Post < ApplicationRecord

  include PostsHelper

  unless Rails.env == 'development'
    include Elasticsearch::Model
    #include Elasticsearch::Model::Callbacks

    __elasticsearch__.client = ApplicationRecord.default_elasticsearch_client
  end 
  
  self.primary_key = :id

  #######################################
  # for role check 
  resourcify
  
  #######################################
  # relations 
  belongs_to :board 
  belongs_to :user 
  
  has_one :post_index, :dependent => :delete
  #has_one :post_content, :dependent => :delete

  # Post와 Comment의 1:N 관계
  has_many :comments, dependent: :destroy
  has_many :post_favors, dependent: :destroy
  has_many :images, dependent: :destroy, foreign_key: 'hint'

  #######################################
  # 콜백 순서 
  # 3.1 Creating an Object
  # before_validation
  # after_validation
  # before_save
  # around_save
  # before_create
  # around_create
  # after_create
  # after_save
  # after_commit/after_rollback

  # 3.2 Updating an Object
  # before_validation
  # after_validation
  # before_save
  # around_save
  # before_update
  # around_update
  # after_update
  # after_save
  # after_commit/after_rollback

  # 3.3 Destroying an Object
  # before_destroy
  # around_destroy
  # after_destroy
  # after_commit/after_rollback
  ####################################

  # events 
  after_initialize :after_initialize
  before_save :before_save 
  before_create :before_create 
  after_create :after_create 
  after_update :after_update 
  after_save :after_save
  after_destroy :after_destroy

  # Post를 입력할 때 content를 반드시 입력해야 함 + 200자 제한
  validates :content, presence: { message: '본문 내용을 입력해주세요.' }
  validates :subject, length: { maximum: 100 }, presence: { message: '제목을 입력해주세요.' }
  validates :category, length: { maximum: 32 }
  validates :name, length: { maximum: 32 }
  validates :nick, length: { maximum: 32 }

  # User와 Post의 관계 때문에 모든 Post는 입력한
  # 사용자의 ID 필드가 입력되어 있어야 함
  validates :user_id, presence: true #, {message: '사용자 정보가 없습니다.'} 

  # User와 Post의 1:N 관계
  # counter_cache는 post 수에 따른 user 리스트를 얻기 위해서
  #belongs_to :user, :counter_cache => :posts_count

  #attr_accessor :site_id 
  attr_accessor :reply, :parent_post_id

  # update 후 indexing 등 작업을 하지 않음. default: false 
  attr_accessor :simple_update_mode 

  #######################################
  # constants

  GID_MAX = (1_000_000_000 - 1).to_f  + 0.00
  PER_PAGE = 20 
  PAGING_TABLE_MIN_PAGE = 200
  POST_INDEX_ATTRS = [:post_id, :gid, :board_id, :board_group_id, :site_id, :notice, :user_id, :category]
  POST_ATTRS = [:id, :gid, :board_id, :board_group_id, :bid, :site_id, 
      :display, :hidden, :notice, :depth, :user_id, :name, :nick, :subject, :category, :content, :files, :files_cnt, :hit,
      :favor_cnt, :unfavor_cnt, :comment_cnt, :report_cnt, :ip, :deleted, :created_at, :updated_at]
  POST_ATTRS__FOR_LISTING = POST_ATTRS - [:files, :content, :source, :ip]

  #named_scope :pure_posts, { :conditions => 'parent_id IS NULL', :order => 'updated_at DESC', :include => [:user, :board] }
  #named_scope :popular_posts, { :conditions => 'parent_id IS NULL', :order => 'views DESC, updated_at DESC', :include => [:user, :board] }
  #named_scope :board_of, lambda { |board| { :conditions => ['board_id = ?', board.id], :order => 'updated_at DESC' }}
  #named_scope :recent, lambda { |*args| { :limit => args.first || 7, :order => 'updated_at DESC', :include => [:user, :board] }}
  
  scope :recent, -> (limit=7) { where("hidden=0 and display=1").order(:gid).limit(limit) } 
  
  #######################################
  # alias 
  alias :post_id :id

  def after_initialize 
    simple_update_mode = false 
  end   
  
  def before_save 
    self.site_id ||= 0
    set_attached_images(self.files, false)
  end

  def post_index
    @post_index ||= PostIndex.find_by(post_id: self.id)
  end
  
  def post_content 
    @content
  end 
  
  def self.post_for_listing(post_id)
    id = post_id.is_a?(Post) ? post_id.id : post_id
    Post.where(id: id).select(POST_ATTRS__FOR_LISTING.join(",")).first
  end 

  def self.recent_posts(**options)
    # options: board_id, board_group_id, site_id, order, recnum, min_favor_cnt, search_interval
    options[:recnum] ||= 7
    options[:recnum] = 100 if options[:recnum] > 100 
    options[:recnum] = 1 if options[:recnum] <= 0    
    
    options[:display] ||= 1
    options[:hidden] ||= 0 
    
    options[:order] ||= :gid 
    options[:order] = :gid if options[:order].nil?
    
    options[:min_favor_cnt] = 0 if options[:min_favor_cnt].nil?
    options[:min_hit] = 0 if options[:min_hit].nil?

    query = Post.where("display = ? and hidden = ?", options[:display], options[:hidden]) 
    query = query.where("board_id = ?", options[:board_id]) if !options[:board_id].nil? 
    query = query.where("board_group_id = ?", options[:board_group_id]) if !options[:board_group_id].nil?
    query = query.where("site_id = ?", options[:site_id]) if !options[:site_id].nil? 
    query = query.where("favor_cnt >= ?", options[:min_favor_cnt]) if options[:min_favor_cnt] > 0
    query = query.where("hit >= ?", options[:min_hit]) if options[:min_hit] > 0
    query = query.where("created_at >= ?", Time.now - options[:search_interval]) if !options[:search_interval].nil?
    query = query.order(options[:order]) 
      .limit(options[:recnum])
      
    query
  end 

  def set_attached_images(image_ids, save = true)
    # image_ids : comma(,) separated id array string 
    # image_ids 개수 == images_cnt 
    
    image_ids ||= ""    
    image_ids_arr = image_ids.split(",")

    # 첨부 이미지에 hint 값에 post_id 를 추가. (post 생성 전에 생성된 이미지에는 hint에 post_id가 입력되어 있지 않음) 
    changed_cnt = 0
    image_cnt1 = 0
    image_ids_arr.each do |img_id|
      change_col_cnt = 0
      begin 
        img = Image.where("id = ?", img_id).first
        if !img.nil?
          # img.hind == post_id 
          (img.hint = self.id; change_col_cnt += 1) if img.hint == nil || img.hint != self.id 
          (img.save!; changed_cnt += 1) if change_col_cnt > 0
          image_cnt1 += 1
        end 
      rescue ActiveRecord::RecordNotFound => e 
      end 
    end
    
    # # 첨부 이미지 목록에 없는 이미지는 삭제. 
    # self.images.each do |x| 
      # #logger.error "############# removing: #{x}"
      # x.destroy! unless image_ids_arr.include?(x.id.to_s)
    # end 
    
    # post에 image_cnt 값 업데이트 
    if self.files_cnt != image_cnt1
      self.files_cnt = image_cnt1 
      self.save! if save 
    end 
  end 
    
  def get_ogimage 
  
    #do_fetch_post_content
    
    image_ids = self.files&.split(',') || []
    img = get_upload_image(self.content, "png|jpg|jpeg|gif", image_ids)
 
    return nil if img.nil?
    
    uri = nil 
    
    if img.include?(".") # it's a url 
      uri = img 
      
    else # it's a image id 
      img1 = Image.where("id = ?", img).first
      if !img1.nil?
        uri = img1.file.url
      end 
    end 
    
    uri 
  end 

  # def inc_hit(id)
  #   # 세션에 저장되어 있지 않으면 
  #   if session[:post_view].index("[#{id}]").nil? then 
  #     #p = self.find(id)
  #     self.hit += 1 
  #     self.save 
  
  #     session[:post_view] += "[#{id}]" 
  #   end 
  # end
  
  # def self.with(indie_bid)
    # self.table_name = self.table_name_prefix + self.make_indie_table_name(indie_bid)
    # self
  # end 
  
  # def self.make_indie_table_name(indie_bid)
    # indie_bid.nil? ? "posts" : ("posts_" + indie_bid) 
  # end
  
  # def self.create_indie_table(indie_bid = nil)
  
    # table_name1 = make_indie_table_name(indie_bid)

    # ActiveRecord::Migration.class_eval do    
      # create_table table_name1, id: :integer, options: "ENGINE=MyISAM" do |t|    
        # t.float :gid
        
        # t.belongs_to :board, index: true, type: :integer
        # t.string :bid, limit:16, default:""
        
        # t.integer :display, limit: 1, null: false, default: 1
        # t.integer :hidden, limit: 1, null: false, default: 0
        # t.integer :notice, limit: 1, null: false, default: 0 
        # t.integer :depth, limit: 1, null: false, default: 0 
        
        # t.belongs_to :user, index: true, type: :integer
        # t.string :name, limit:32
        # t.string :nick, limit:32
        
        # t.string :subject, limit:100
        # t.mediumtext :content
        # t.string :category, limit:32
        # t.string :html, limit:4, null: false, default: "html"
        # t.string :tag

        # t.integer :hit, null: false, default: 0 
        # t.integer :comment_cnt, null: false, default: 0 
        # #t.integer :ip, unsigned: true, null: false, default: 0
        # t.string :ip, limit:25, null: false, default:''
        # t.integer :report_cnt, null: false, default: 0 #신고 

        # t.timestamps
      
        # t.index :gid 
        # t.index :bid 
        # t.index :display
        # t.index :notice 
        # t.index :hidden 
      # end    
      # change_column table_name1, :gid, :double, precesion: "11,2", null: false, default: "0.00"
    # end
    
  # end  
  
  # def self.destroy_indie_table(indie_bid) 
    # table_name1 = indie_bid || self.table_name
    # ActiveRecord::Migration.class_eval do    
      # drop_table table_name1
    # end 
  # end 
  
  def is_new 
	  created_at.to_date >= (Time.now - 2.days)
  end 

  # def author 
    # User.find()
  # end 
  
  def comments
    #indie_bid = self.indie_bid_from_table_name 
    Comment.where(post_id: self.id).order('gid, reply_order')
  end
  
  def calc_comments_count
    Comment.where("post_id=? and deleted=0", self.id).count
  end 

  def next_gid
    max_gid = ActiveRecord::Base.connection.select_values("SELECT MIN(gid) AS max_gid FROM `" + Post.table_name + "`")
    return (max_gid[0] || GID_MAX) - 1.00
  end
  
  def dup
    ActiveRecord::Base.transaction do
      # duplicate post 
      new_p = super
      # self.comments.each { |c|
        # new_c = c.dup
        # new_c.post_id = new_p.id 
        # new_c.save
      # }
      new_p.gid = Post.next_gid
      new_p.comment_cnt = 0
      #new_p.favor_cnt = 0
      #new_p.report_cnt = 0
      #new_p.favor_cnt = 0
      new_p.save
      
      # duplicate post_index
      newidx = self.post_index.dup
      newidx.gid = new_p.gid 
      newidx.post_id = new_p.id 
      newidx.save      
    end 
    
    new_p
  end
  
  def dup_with_comments    
    ActiveRecord::Base.transaction do 
      new_post = self.dup
      new_post.comment_cnt = self.comment_cnt
      dup_comments(new_post)
      new_post
    end 
  end
  
  def expire_cache
    delete_cache("posts/#{id}")
  end
  
  def invalidate_post_paging 
    # expire for count count 
    delete_cache("posts/list_notice/#{board_id}")
    delete_cache("posts/notice_cnt/#{board_id}")
    delete_cache("posts/total_cnt/#{board_id}")

    # expire for post list 
    delete_cache("posts/group_list_notice/#{board_group_id}")
    delete_cache("posts/group_notice_cnt/#{board_group_id}")
    delete_cache("posts/group_total_cnt/#{board_group_id}")

    delete_cache("posts/board/#{board_id}/postcache_valid")
    delete_cache("posts/board_group/#{board_group_id}/postcache_valid")
  end 

  #######################################
  # change data 

  def change_category(new_cat)
    self.category = new_cat
    self.save
    idx = self.post_index
    idx.category = new_cat
    idx.save
  end
  
  def change_board_id(board_id)
    self.board_id = board_id
    self.save
    idx = self.post_index
    idx.board_id = board_id
    idx.save
  end
  
  def change_board_group_id(board_group_id)
    self.board_group_id = board_group_id
    self.save
    idx = self.post_index
    idx.board_group_id = board_group_id
    idx.save
  end
  
  #######################################
  # Elasticsearch index mapping setting 

  unless Rails.env == 'development'  
    index_name    "post-#{Rails.env}"
    document_type "post"

    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :bid, index_options: 'docs'
        indexes :board_id, type:'integer', index_options: 'docs'
        indexes :name, analyzer: 'nori', index_options: 'docs'
        indexes :nick, analyzer: 'nori', index_options: 'docs'
        indexes :subject, analyzer: 'nori', index_options: 'offsets'
        indexes :content, analyzer: 'nori', index_options: 'offsets'
        indexes :post_content, analyzer: 'nori', index_options: 'offsets'
        indexes :display, type:'integer', index_options: 'docs'
        indexes :hidden, type:'integer', index_options: 'docs'
      end
    end

    def as_indexed_json(options={})
      record = { 
        board_id: board_id, 
        board_group_id: board_group_id, 
        name: name, 
        nick: nick, 
        subject: subject, 
        #content: ActionView::Helpers::SanitizeHelper::sanitize(post_content&.content), #Sanitize.fragment(post_content&.content, Sanitize::Config::RELAXED),
        content: Sanitize.fragment(post_content&.content, Sanitize::Config::RELAXED),
        display: display, 
        hidden: hidden }
        
      #JSON.generate(record)
    end
      
    def self.create_index(force = true)
      self.__elasticsearch__.create_index! force: force
    end    
    
    def self.__my_import
      Post.find_each(:batch_size => 1000) do |p|        
        begin 
          p.__elasticsearch__.index_document
          print "[#{p.id}] "; 
        rescue Exception => e 
          pp e.to_s 
        end
      end 
    end      
  end   
  
  def self.search(query, where_list, board_id, page = 1, per_page = 20)

    return nil if Rails.env == 'development'
    
    #where_list = ['subject', 'content', 'nick']
    from = (page - 1) * per_page
    
    match_list = where_list.map { |x|
      case x 
      when 'nick'
        { match: { "#{x}": query } }
      else
        { match_phrase: { "#{x}": query } }
      end
    }
    
    if !board_id.nil? 
      match_list += [
        { match: { board_id: board_id }},
      ]
    end 
    
    # filter_list = [
      # { term: { display: 1 }}
      # { term: { hidden: 1 }}
    # ]
    
    #pp match_list
    
    __elasticsearch__.search(
      {
        query: {
          bool:  {
            must: match_list, 
            #filter: filter_list
          }
        },
        from: from,
        size: per_page,
      }
    )
  end

  #######################################
  
  
  private
  
    def dup_comments(new_post)
    
      cmt_gids = Hash.new 
      cmd_id_changes = Hash.new 
      cmt_parent_ids = Hash.new 
      
      comments1 = Comment.where(post_id: self.id).order('id')
      comments1.each { |c|
        #puts "reo: #{c.reply_order}"
        new_c = c.dup
        new_c.post_id = new_post.id
        new_c.save
        
        cmt_parent_ids[c.id] = c.parent_id 
        #puts "@1 pid       #{c.id} --> #{c.parent_id}"
        
        cmd_id_changes[c.id] = new_c.id
        #puts "@2 idchange  #{c.id} --> #{new_c.id}"
        
        if c.id == c.gid # it is top level comment 
          cmt_gids[c.id] = new_c.id 
          #puts "@3 #{c.id} --> #{new_c.id}"
          new_c.gid = new_c.id 
        else 
          new_c.gid = cmt_gids[c.gid]
          #puts "@4 gid #{c.gid} --> #{ cmt_gids[c.gid] }"
        end
        
        if c.parent_id == 0 
          new_c.parent_id = 0 
        else 
          new_c.parent_id = cmd_id_changes[ cmt_parent_ids[ c.id ] ] || 0 
          cmt_parent_ids[new_c.id] = new_c.parent_id
          #puts "@5 pid set #{ new_c.id } --> #{ new_c.parent_id } "
        end 

        new_c.reply_order = c.reply_order        
        new_c.save
      }
      
    end 

    def self.indie_bid_from_table_name
      Regexp.new("posts_(.*)").match(self.table_name)
      $1
    end 
  
    def before_create 

      #validates_presence_of :parent_post_id if @reply.present? 
      if @reply then
        unless @parent_post_id 
          self.errors.add("더 이상 답글을 달 수 없습니다.")
          return false 
        end

        p = Post.where(id: @parent_post_id).first
        gid_int = p.gid.to_i 
        re_cnt = Post.where("gid >= ? and gid < ?", gid_int, gid_int+1).count
        if re_cnt >= 98 then 
          self.errors.add("더 이상 답글을 달 수 없습니다.")
          return false 
        end

        Post.where("gid > ? and gid < ?", p.gid, gid_int+1).update_all('gid = gid + 0.01')

        self.gid = p.gid + 0.01
        self.depth = p.depth + 1

      else 
        self.gid = next_gid
      end 
    end
    
    def after_create
      create_post_index
      invalidate_post_paging
    
      if self.user_id
        userdata = self.user.data
        userdata.total_post_cnt += 1 
        userdata.save!
        
        # 게시물 작성 포인드 지급 
        User.send_point_by_admin(self.user_id, PointLog::points_for_acton(:post), "게시물 작성에 대한 포인트")
      end

    end 

    def after_update
      
      return if simple_update_mode 
      
      update_post_index
    end

    def after_save
      # begin 
        # raise "error"
      # rescue Exception => e 
        # logger.error e.backtrace.join "\n" 
      # end 
      expire_cache
    end
    
    def create_post_index
      # PostIndex도 새로 생성 
      begin 
        newpi = PostIndex.new do |pi|
          POST_INDEX_ATTRS.each do |attr|
            pi.send("#{attr}=", self.send(attr))
          end
        end
        newpi.save!
      rescue Exception => e 
        logger.error e.to_s 
      end 
    end
  
    def update_post_index 
      # PostIndex에도 업데이트 
      # 없으면 새로 생성 
      if post_index.nil? 
        create_post_index
      else 
        begin 
          pi = post_index 
          POST_INDEX_ATTRS.each do |attr|
            pi.send("#{attr}=", self.send(attr)) unless send(attr) == pi.send(attr)
          end 
          pi.save!
        rescue Exception => e 
          logger.error e.to_s 
        end 
      end
    end
        
    def after_destroy
      expire_cache
      invalidate_post_paging
      
      if self.user_id
        userdata = self.user.data
        userdata.total_post_cnt -= 1
        userdata.save!
        
        # 게시물 삭제 포인드 지급 
        User.send_point_by_admin(self.user_id, PointLog::points_for_acton(:post_del), "게시물 삭제에 대한 포인트")
      end
    end
    

  # class << self
  #   @@model_class = {}

  #   # Create derived class for id
  #   @@model_class[id] = Class.new(Post)
  #   @@model_class[id].set_table_name "post_#{id}"
  #   # Repeat for other IDs
  # end
    
end
