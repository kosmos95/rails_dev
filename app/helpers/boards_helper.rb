module BoardsHelper

  def cached_board_new_post_count_code(bid, interval = 2.days)   
    content_tag(:span, class: "count") do 
      count = cached_board_new_post_count(bid, interval)
      count > 0 ? 
        number_to_human(count, units: {unit: "", thousand: "k", million: "M", billion: "G"}, precision: 2) : 
        ""
    end
  end 
  
  def cached_board_new_post_count(bid, interval = 2.days)
    board_id = Board.cached_board_by_bid(bid)&.id || 0
    count = Board.cached_recent_posts_count(board_id, interval)
    count
  end
  
  def url2bid(url) 
    re_board = %r{.*/board/([^/.]+)}
    url.match(re_board)
    $1
  end 
  
end
