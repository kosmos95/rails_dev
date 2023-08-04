# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "=== seed ===================================== "

require 'date'

s = Site.create!(name:'default')
t = Theme.create!(name:'default', parent_id:s.id)

m = Menu.create!(site_id:s.id, name:"main", content: YamlMenu.yaml)

bg1 = BoardGroup.create(bgid:'main', name:'기본')
bg2 = BoardGroup.create(bgid:'humor', name:'재미공간')
bg3 = BoardGroup.create(bgid:'hanryu', name:'한류공간')
bg4 = BoardGroup.create(bgid:'info', name:'소통공간')
bg5 = BoardGroup.create(bgid:'hobby', name:'취미공유방')
bg6 = BoardGroup.create(bgid:'fanclub', name:'한류스타')

puts "### creating boards" 
b1 = Board.create( bid:'gongji', name:'공지', board_group_id:bg1.id ) 
Board.create( bid:'hanmadi', name:'공지', board_group_id:bg1.id ) 
Board.create( bid:'ccheck', name:'출석체크', board_group_id:bg1.id ) 

b2 = Board.create( bid:'jayouboard', name:'자유게시판', board_group_id:bg2.id ) 
Board.create( bid:'hansosik', name:'한류열풍소식', board_group_id:bg2.id ) 
Board.create( bid:'jaemiphoto', name:'재밌는 사진방', board_group_id:bg2.id ) 
Board.create( bid:'jaemivideo', name:'재밌는 영상방', board_group_id:bg2.id ) 
Board.create( bid:'bimilbang', name:'비밀의 화원', board_group_id:bg2.id ) 

Board.create( bid:'hangulstudy', name:'한국어와 한글방', board_group_id:bg3.id ) 
Board.create( bid:'hanmusic', name:'한국 음악방', board_group_id:bg3.id ) 
Board.create( bid:'hanvideo', name:'한국 영상방(영화/드라마/애니)', board_group_id:bg3.id ) 
Board.create( bid:'hancoverdance', name:'한류 커버댄스방', board_group_id:bg3.id ) 
Board.create( bid:'hanhistory', name:'한국 역사방', board_group_id:bg3.id ) 
Board.create( bid:'hanfood', name:'한식사랑&디미방', board_group_id:bg3.id ) 
Board.create( bid:'hanfashion', name:'한국 아트백서(뷰티&패션)', board_group_id:bg3.id ) 
Board.create( bid:'hantravel', name:'한국 여행/맛집/축제', board_group_id:bg3.id ) 
Board.create( bid:'hannuri', name:'한국 누리별방(SNS,Youtube)', board_group_id:bg3.id ) 

Board.create( bid:'overseas_exp', name:'생생외국 경험방', board_group_id:bg4.id ) 
Board.create( bid:'korean_exp', name:'생생한국 경험방', board_group_id:bg4.id ) 
Board.create( bid:'overseas_trans', name:'해외반응번역', board_group_id:bg4.id ) 
Board.create( bid:'korean_trans', name:'한국반응번역', board_group_id:bg4.id ) 
Board.create( bid:'request_trans', name:'번역요청 게시판', board_group_id:bg4.id ) 

Board.create( bid:'itscieco', name:'IT/과학/경제', board_group_id:bg5.id ) 
Board.create( bid:'weapon', name:'국방/군사/무기', board_group_id:bg5.id ) 
Board.create( bid:'xevent', name:'재난대비', board_group_id:bg5.id ) 
Board.create( bid:'broadcast', name:'방송/연예', board_group_id:bg5.id ) 
Board.create( bid:'socicult', name:'사회/문화', board_group_id:bg5.id ) 
Board.create( bid:'politics', name:'정치', board_group_id:bg5.id ) 
Board.create( bid:'modrani', name:'영화/드라마/애니', board_group_id:bg5.id ) 
Board.create( bid:'mystery', name:'미스터리', board_group_id:bg5.id ) 
Board.create( bid:'food1', name:'음식', board_group_id:bg5.id ) 
Board.create( bid:'plmusical', name:'연극/뮤지컬', board_group_id:bg5.id ) 
Board.create( bid:'books', name:'도서', board_group_id:bg5.id ) 
Board.create( bid:'classic', name:'클래식/공연', board_group_id:bg5.id ) 
Board.create( bid:'artexibi', name:'미술/전시회', board_group_id:bg5.id ) 
Board.create( bid:'webtoon1', name:'웹툰', board_group_id:bg5.id ) 
Board.create( bid:'onlinegame', name:'온라인 게임', board_group_id:bg5.id ) 
Board.create( bid:'sports', name:'스포츠', board_group_id:bg5.id ) 
Board.create( bid:'car', name:'자동차', board_group_id:bg5.id ) 

Board.create( bid:'shinhwa', name:'신화(SHINHWA)', board_group_id:bg6.id )
Board.create( bid:'god5', name:'GOD', board_group_id:bg6.id ) 
Board.create( bid:'bts', name:'방탄소년단(BTS)', board_group_id:bg6.id ) 
Board.create( bid:'exo', name:'엑소(EXO)', board_group_id:bg6.id ) 
Board.create( bid:'btobto1', name:'BTOB', board_group_id:bg6.id ) 
Board.create( bid:'monsterx', name:'몬스타엑스(MonsterX)', board_group_id:bg6.id ) 
Board.create( bid:'nct16', name:'NCT16 ', board_group_id:bg6.id ) 
Board.create( bid:'got7', name:'갓세븐(GOT7) ', board_group_id:bg6.id ) 
Board.create( bid:'seventeen', name:'세븐틴(SVT) ', board_group_id:bg6.id ) 
Board.create( bid:'nuest', name:'뉴이스트(NU\'EST)', board_group_id:bg6.id ) 
Board.create( bid:'vixx', name:'빅스(VIXX)', board_group_id:bg6.id ) 
Board.create( bid:'astro', name:'아스트로(ASTRO) ', board_group_id:bg6.id ) 
Board.create( bid:'jbj', name:'제이비제이(JBJ)', board_group_id:bg6.id ) 
Board.create( bid:'hotshot1', name:'핫샷(HOTSHOT)', board_group_id:bg6.id ) 
Board.create( bid:'oneus', name:'원어스(ONEUS)', board_group_id:bg6.id ) 
Board.create( bid:'ab6ix', name:'AB6IX', board_group_id:bg6.id ) 
Board.create( bid:'txt', name:'투모로우바이투게더(TXT)', board_group_id:bg6.id ) 
Board.create( bid:'apink', name:'에이핑크(APINK)', board_group_id:bg6.id ) 
Board.create( bid:'redvelvet', name:'레드벨벳(Red Velvet)', board_group_id:bg6.id ) 
Board.create( bid:'twice', name:'트와이스(TWICE)', board_group_id:bg6.id ) 
Board.create( bid:'gfriend', name:'여자친구(GFriend)', board_group_id:bg6.id ) 
Board.create( bid:'lovelyz', name:'러블리즈(Lovelys)', board_group_id:bg6.id ) 
Board.create( bid:'ohmygirl', name:'오마이걸(Ohmygirl)', board_group_id:bg6.id ) 
Board.create( bid:'mamamoo', name:'마마무(MAMAMOO)', board_group_id:bg6.id ) 
Board.create( bid:'dreamcatcher', name:'드림캐쳐(Dreamcatcher)', board_group_id:bg6.id ) 
Board.create( bid:'momoland', name:'모모랜드(MOMOLAND)', board_group_id:bg6.id ) 
Board.create( bid:'wjsn', name:'우주소녀(WJSN)', board_group_id:bg6.id ) 
Board.create( bid:'gugudan', name:'구구단(Gugudan)', board_group_id:bg6.id ) 
Board.create( bid:'itzy', name:'잇지(ITZY)', board_group_id:bg6.id ) 
Board.create( bid:'wekimeki', name:'위키미키(Weki Meki)', board_group_id:bg6.id ) 
Board.create( bid:'izone', name:'아이즈원(IZ*ONE)', board_group_id:bg6.id ) 
Board.create( bid:'favorite', name:' 페이버릿(Favorite)', board_group_id:bg6.id ) 

puts "### creating post" 
Post.create(board_id:b1.id, bid:b1.bid, board_group_id:b1.board_group_id, subject:'subject1', content:'text1')
Post.create(board_id:b1.id, bid:b1.bid, board_group_id:b1.board_group_id, subject:'subject2', content:'text2')
Post.create(board_id:b2.id, bid:b2.bid, board_group_id:b1.board_group_id, subject:'subject3', content:'text3')
Post.create(board_id:b2.id, bid:b2.bid, board_group_id:b1.board_group_id, subject:'subject4', content:'text4')

puts "### creating levels" 
Level.init_levels 

puts "### creating user group" 
Level.init_levels 

ug1 = UserGroup.create(name:'기본') 
ug2 = UserGroup.create(name:'운영자') 

#if Rails.env.development?
  puts "### creating user" 
  u1 = User.create(email: 'damulkan@naver.com', name:'나의택1', nick:'닉네임1', password: 'admin1234', password_confirmation: 'admin1234', confirmed_at: DateTime.now, user_group_id: ug2.id) 
  u1.add_role :admin 
  u1.add_role :superadmin
  u1.save
  u2 = User.create(email: 'damulhan@gmail.com', name:'나의택2', nick:'닉네임2', password: 'admin1234', password_confirmation: 'admin1234', confirmed_at: DateTime.now, user_group_id: ug2.id) 
  u2.add_role :admin 
  u2.save
  u3 = User.create(email: 'damulkan@hanmail.net', name:'나의택3', nick:'닉네임3', password: 'admin1234', password_confirmation: 'admin1234', confirmed_at: DateTime.now, user_group_id: ug1.id)
  #u3.add_role :moderator, Board (전체 게시판 관리자는 없는 걸로..) 
  u3.add_role :moderator, b1 
  u3.save
  u4 = User.create(email: 'greatcorea9000@hanmail.net', name:'나의택4', nick:'닉네임4', password: 'admin1234', password_confirmation: 'admin1234', confirmed_at: DateTime.now, user_group_id: ug1.id)
  u4.save
  u5 = User.create(email: 'test@hanmail.net', name:'TEST', nick:'TEST', password: 'test1234', password_confirmation: 'test1234', confirmed_at: DateTime.now, user_group_id: ug2.id)
  u5.add_role :admin 
  u5.save
  u6 = User.create(email: 'giha2000@hanmail.net', name:'박찬화', nick:'지천태', password: 'test1234', password_confirmation: 'test1234', confirmed_at: DateTime.now, user_group_id: ug2.id)
  u6.add_role :admin 
  u6.save

  b1 = Board.find_by(bid:'gongji') if b1.nil?   
  puts "### creating sample posts" 
  sample_post = "샘플 제목 " * 300
  (1..2000).each do |x| 
    Post.create(board_id:b1.id, bid:b1.bid, board_group_id:b1.board_group_id, subject:"subject 제목 #{x}", content:"text2 #{x}\n"+sample_post, user_id:u1.id, name:u1.name, nick:u1.nick)
    print "."
    #sleep 1
  end 
#end 

u1 = User.first if u1.nil? 
b1 = Board.find_by(bid:'gongji') if b1.nil?
puts "### creating sample posts"
sample_post = "샘플 제목 " * 300
(1..200000).each do |x|
  Post.create(board_id:b1.id, bid:b1.bid, board_group_id:b1.board_group_id, subject:"subject 제목 #{x}", content:"subject 제목 #{x}\n"+sample_post, user_id:u1.id, name:u1.name, nick:u1.nick)
  print "."
end

# sample_post = "sample " * 300; (1..30000).each do |x| Post.create(board_id:1, bid:'free', subject:"subject #{x}", content:"text2 #{x}\n"+sample_post, user_id:1, name:'admin', nick:'admin'); end 

# (1..10000).each { |i| 
  # ug1 = UserGroup.find_by(name:'기본') if ug1.nil? 
  # u1 = User.create(email: "testuser#{i}@naver.com", name:"닉네임#{i}", nick:"닉네임#{i}", password: 'admin1234', password_confirmation: 'admin1234', confirmed_at: DateTime.now, user_group_id: ug1.id) 
  # u1.save  
# }
