$str = <<EOM
  기준금리 3년만에 0.25%p 전격 인하…"성장률 2%대 초반"
  "월급쟁이 삼성 이학수, 수조원 재산 어떻게 모았을까"
  文·黃대표 등 '회담준비 총력'…핵심은 '日 수출규제' 대책
  與, 사개특위 대신 정개특위 선택…위원장에 홍영표
  '대북 쌀지원' 남→북 항로로 보낼듯…제재면제 절차 진행
  정경두 "장병 원하는 날짜에 원하는 곳에서 진료받도록 할 것"
  '성폭행 피소' 김준기 전 DB 회장 "주치의 허락 받고 귀국"
  다나스 20일 새벽 제주도 통과…재난안전본부 비상근무
  홍익표 "청와대, '조선·중앙일보' 공개적 비판? 문제없어"
  김성원 의원 교통사고 당해…운전비서 음주 적발
EOM

$subjects = $str.split("\n").map(&:strip)

def add_post_to_board(bid)
  u1 = User.first if u1.nil? 
  b1 = Board.find_by(bid: bid) if b1.nil?
  
  if b1.nil? 
    puts "no such board: #{bid}"; return; 
  end 
  
  puts "### creating sample posts"
  sample_post = "(우리는) 동방 한국인의 잃어버린 역사를 되찾고 원형문화정신을 .." * 100
  sample_title = "#{b1.name} " * 10 
  (1..2000).each do |x|
    subject = "#{x} #{$subjects[x % $subjects.length]}"
    subject_slip = subject[0..30] + "..."
    Post.create(board_id:b1.id, bid:b1.bid, board_group_id:b1.board_group_id, subject: subject, content:"subject 제목 #{x}\n"+sample_post, user_id:u1.id, name:u1.name, nick:u1.nick)
    print "."
  end
end 

bgids = [:main, :humor, :hanryu, :info, :hobby, :fanclub]

bgids.each do |bgid|
  #board = Board.joins(:board_group).find_by(bgid: bgid).first 
  bg = BoardGroup.where(bgid: bgid).first 
  boards = Board.where(board_group_id: bg.id).all
  boards.each do |board|
    add_post_to_board(board.bid)
  end 
end 
