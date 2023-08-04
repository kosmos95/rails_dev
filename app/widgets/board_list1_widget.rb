require 'action_widget'

class BoardList1Widget < ActionWidget::Base
  property :title, required: false, converts: :to_s
  # //property :id, required: false, converts: :to_s
  property :klass, required: false, converts: :to_s, default: ''
  # //property :show_date, default: false 
  property :link, converts: :to_s
  
  #property :board_id, required: false, converts: :to_i
  #property :bid, required: false, converts: :to_s
  
  #property :board_group_id, required: false, converts: :to_i
  property :bgid, required: false, converts: :to_s
  
  property :site_id, required: false, converts: :to_i  
  #property :hidden, required: false, converts: :to_i 
  #property :display, required: false, converts: :to_i 

  property :order, required: false, default: :gid
  property :recnum, required: false, default: 7

  def render()
    board_group_id = board_group_id_for(bgid) if !bgid.nil?
    return if board_group_id.nil? 
    
    board_group = BoardGroup.find(board_group_id)
    boards = board_group.boards_for_display
    
    content_tag(:div, class: klass) do 
      (header + body(boards) + bottom).html_safe
    end
  end
  
  def header
    if title.present? 
      out = content_tag(:h6, class: 'title') do 
         content_tag(:a, href: link, target: '') do 
          title 
        end
      end 
    end 
    out || ""
  end
  
  def body(boards)
    content_tag(:ul) do
      str = boards.collect do |b| 
        content_tag(:li, class: 'board') do 
          content_tag(:a, href: board_posts_path(b.bid), target: '') do 
            _namecut(b.name, 20) 
          end + 
          content_tag(:span, class: 'count') do 
            count = Board.cached_recent_posts_count(b.id, 48.hours)
            count > 0 ? 
              "(" + number_to_human(count, units: {unit: "", thousand: "k", million: "M", billion: "G"}, precision: 2) + ")" :
              ""
          end
        end
      end.join.html_safe
      str += "<div style='clear:both'></div>".html_safe
    end    
  end
  
  def bottom
    ""
  end 
  
  def _namecut(name, chars = 3)   
    name[0..(chars-1)]
  end 

end

