#require 'ipaddr'

class CommentsController < ApplicationController

  around_action :run_using_slave, only: [:index, :show, :edit, :check_new, :set_post, :set_comment]

  before_action :set_post, only: [:create]
  before_action :set_comment, only: [:destroy, :favor, :update, :reportabuse]

  #validates :image, :file_size => { :maximum => 1.megabytes.to_i } 

  def create
    @comment = @post.comments.new(comment_params)

    if current_user then
      if params[:comment][:content] == ''
        @comment.errors.add(:error, I18n.t('hcafe2.comment.no_content'))
      else
        # 그래도 comment가 post와 user에 belongs_to이기 때문에 user 정보가 없으면 생성되지 않는 것 같다.
        @comment.post_id = @post.id
        @comment.board_id = @post.board_id
        @comment.user_id = current_user_id
        @comment.ip = request.remote_ip 
        @comment.ip = request.env['HTTP_X_REAL_IP'] || request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip if @comment.ip == '127.0.0.1'

        result  = @comment.save
        (@comment.gid = @comment.id; @comment.save) if @comment.gid.nil? || @comment.gid == 0
        
        # 상위 post 테이블에 카운트 추가 
        post = @comment.post
        post.comment_cnt += 1
        post.save(validate: false)
        
        current_user.data.incr_level_upgrade_value(:comment_cnt)
        current_user.data.incr_count_value(:total_cmt_cnt)
        
      end
    else
      @comment.errors.add(:error, I18n.t("hcafe2.general.please_login"))
    end

    respond_to do |format|
      format.js {render layout: false}
    end

  end

  def update
    @comment.update(comment_params)
    
  end
  
  def check_new 
    @post_id = params[:post_id].to_i
    @curr_max_id = params[:max_id].to_i 
    @comments = Comment
      .where("post_id = ? AND id > ?", @post_id, @curr_max_id)
      .order('gid, reply_order')
  end 

  def destroy!
    # 상위 post 테이블에 카운트 삭제 
    post = @comment.post
    post.comment_cnt -= 1 
    post.save(validate: false)

    @comment.destroy
    
  end
  
  def destroy
    # 상위 post 테이블에 카운트 삭제 
    post = @comment.post
    post.comment_cnt -= 1 
    post.save
    
    Rails.logger.info(post.errors.inspect)     

    @soft_deleted = false
    @force = params[:force] 

    children_cnt = @comment.children.count 

    if children_cnt > 0 && !params[:force].present?
      @comment.soft_delete!
      @soft_deleted = true 
    else 
      @comment.destroy
    end 

  end
  
  def favor 
    authorize! :read, @comment
    
    @favor_added = 0 
    
    @favor_cnt = @comment.comment_favors.where('favored_user_id=?', current_user_id).count 
    
    if @favor_cnt == 0 
      @comment.favor_cnt ||= 0 
      @comment.favor_cnt += 1 
      @comment.save 
      
      favors = @comment.comment_favors.new
      favors.favored_user_id = current_user.id
      favors.save
      
      @favor_added = 1
    end 
    
  end   
  
  def reportabuse
    authorize! :read, @comment
    
    # post:1, comment:2 
    target_type = 2  # comment 
    
    @report_added = 0
    @report_cnt = Reportabuse.where('user_id=? and target_type=? and target_id=?', current_user_id, target_type, @comment.id).count 
    
    if @report_cnt == 0     
      @comment.report_cnt ||= 0 
      @comment.report_cnt += 1 
      @comment.save 
      
      report = Reportabuse.new 
      report.user_id = current_user.id 
      report.target_type = target_type
      report.target_id = @comment.id 
      report.reason = ActionController::Base.helpers.sanitize( params[:reason] )
      report.save
      
      @report_added = 1
    end
        
  end
  
  private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      #@comment = @post.comments.find(params[:id])
      @comment = Comment.find(params[:id])
    end

    def comment_params
      if action_name == 'update' then 
        a = params.require(:comment).permit(:content, :image, :img_pos, :remove_image )
      else 
        a = params.require(:comment).permit(:content, :name, :nick, :user_id, :reply, :parent_id, :image, :remove_image, :img_pos)
        a[:name] ||= current_user.name
        a[:nick] ||= current_user.nick
      end 
      a
    end
    
end
