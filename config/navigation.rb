SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = SimpleNavigationRenderers::Bootstrap3
  navigation.items do |primary|
    primary.item :news, {icon: "fa fa-fw fa-bullhorn", text: "게시판"}, board_posts_path(1)
    primary.item :concerts, "공지", board_posts_path(2)
    primary.item :video, "Video", '/about'
    primary.item :divider_before_info, '#', divider: true
    primary.item :info, {icon: "fa fa-fw fa-book", title: "Info"}, '/info', split: true do |info_nav|
    info_nav.item :main_info_page, "Main info page", '/about'
    info_nav.item :about_info_page, "About", '/about'
    info_nav.item :misc_info_pages, "Misc." do |misc_page|
      misc_page.item :header_misc_pages, "Misc. Pages", header: true
      #Info.all.each do |info_page|
      #misc_page.item :"#{info_page.permalink}", info_page.title, info_path(info_page)
      #end
    end
    info_nav.item :divider_before_contact_info_page, '#', divider: true
    info_nav.item :contact_info_page, "Contact", '/info' #info_path(:contact_info_page)
    end
    primary.item :singed_in, "Signed in as Pavel Shpak", navbar_text: true
  end
end
