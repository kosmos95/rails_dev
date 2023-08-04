u1 = User.first if u1.nil? 
b1 = Board.find_by(bid:'gongji') if b1.nil?
puts "### creating sample posts"
sample_post = "샘플 제목 " * 300
(1..200000).each do |x|
  Post.create(board_id:b1.id, bid:b1.bid, board_group_id:b1.board_group_id, subject:"subject 제목 #{x}", content:"subject 제목 #{x}\n"+sample_post, user_id:u1.id, name:u1.name, nick:u1.nick)
  print "."
end