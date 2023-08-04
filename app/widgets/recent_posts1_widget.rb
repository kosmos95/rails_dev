require 'action_widget'

class RecentPosts1Widget < ActionWidget::Base
  property :title, required: false, converts: :to_s
  property :id, required: false, converts: :to_s
  property :klass, required: false, converts: :to_s, default: 'widget_recentposts1'
  property :show_date, default: false 
  property :more_link, converts: :to_s
  
  property :board_id, required: false, converts: :to_i
  property :bid, required: false, converts: :to_s
  
  property :board_group_id, required: false, converts: :to_i
  property :bgid, required: false, converts: :to_s
  
  property :site_id, required: false, converts: :to_i  
  #property :hidden, required: false, converts: :to_i 
  #property :display, required: false, converts: :to_i 

  property :order, required: false, default: :gid, converts: :to_s
  property :recnum, required: false, default: 7, converts: :to_i
  property :min_favor_cnt, required: false, default: 0, converts: :to_i
  property :min_hit, required: false, default: 0, converts: :to_i
  property :search_interval, required: false, default: nil

  def render()
    #posts = Post.where('hidden=0 and display=1').order(:gid).limit(recnum)
    
    board_id = board_id_for(bid) if !bid.nil?
    board_group_id = board_group_id_for(bgid) if !bgid.nil?
    
    posts = Post.recent_posts(
      board_id: board_id, board_group_id: board_group_id, site_id: site_id, 
      order: order, recnum: recnum, min_favor_cnt: min_favor_cnt, min_hit: min_hit, search_interval: search_interval)
    
    #post_indices = PostIndex.recent_post_indices( 
    #  board_id: board_id, board_group_id: board_group_id, site_id: site_id, 
    #  order: order, recnum: recnum)
      
    #posts = post_indices.map { |p| get_post(p) }
    
    content_tag(:div, class: klass) do 
      (header + body(posts) + bottom).html_safe
    end
  end
  
  def header
    out = content_tag(:h6, title, class: 'title') if title.present?
    out || ""
  end
  
  def body(posts)
    content_tag(:ul) do
      posts.collect do |p| 
        li_class = show_date ? "show_date" : ""
        content_tag(:li, class: li_class) do 
          str = %Q(<span class='board_name'>#{_namecut(board_name_for(p.board_id))}</span>).html_safe
          has_image_icon = (!p.files_cnt.nil? && p.files_cnt > 0) ? '<span class="has_image"><i class="fa fa-picture-o" aria-hidden="true"></i></span>': ""
          str += content_tag(:a, href: board_post_path(p.bid, p.id)) do 
            content_tag(:span, 'ㆍ', class:'dot') + 
            %Q(<span class='list_subject'><span class="subject">#{p.subject}</span>#{has_image_icon}</span>).html_safe 
          end
          str += (p.comment_cnt > 0 ? content_tag(:span, "[#{p.comment_cnt}]", class:'comment') : "")
          if show_date
            str += content_tag(:span, style:"float:right") do
              content_tag(:span, timestr(p.created_at, 4), class:'date')
            end
          end
          str 
        end
      end.join.html_safe
    end
  end 
  
  def bottom
    if more_link then 
      str = %Q(<a href="#{more_link}" class="more"><i class="fa fa-plus" aria-hidden="true"></i></a>)
    else 
      str = ""
    end    
    str.html_safe
  end 
  
  def _namecut(name, chars = 3)   
    name[0..(chars-1)]
  end 

end

