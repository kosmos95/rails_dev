module ApplicationHelper

  DEFAULT_HOST_URL = 'https://www.hanryumoa.net'
  DEFAULT_IMAGE_URL_BASE = 'https://cdn.hanryumoa.net'

  def t(msg, **opt)
    I18n.t msg, **opt
  end
  
  def image_url_base 
    @image_url_base ||= (ENV['image_url_base'] || DEFAULT_IMAGE_URL_BASE)
  end 
  
  def host_url 
    @host_url ||= (ENV['host_url'] || DEFAULT_HOST_URL)
  end 
  
  def board_name_for(board_id) # board_id = integer 
    Rails.cache.fetch("board/#{board_id}/name", expires_in: 1.day) do 
      board = Board.find(board_id);
      board&.name || "(unknown:#{board_id})"
    end
  end
  
  def board_id_for(bid) 
    Rails.cache.fetch("board/#{bid}/id", expires_in: 1.day) do 
      board = Board.find_by(bid: bid);
      board&.id
    end
  end 
  
  def board_group_name_for(board_group_id) # board_group_id == integer 
    Rails.cache.fetch("board_group/#{board_group_id}/name", expires_in: 1.day) do 
      board_group = BoardGroup.find(board_group_id);
      board_group&.name || "(unknown:#{board_group_id})"
    end
  end
  
  def board_group_id_for(bgid) 
    Rails.cache.fetch("board_group/#{bgid}/id", expires_in: 1.day) do 
      BoardGroup.find_by(bgid: bgid)&.id
    end
  end 
  
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def timestr(time, mode=1)
  
    fmt = 
      case mode 
      when 1
        "%Y-%m-%d %H:%M:%S"
      when 2 
        "%H:%M:%S"
      when 3
        "%Y-%m-%d"		
      when 4 
        if Time.now.to_date > time.localtime.to_date
        "%y-%m-%d"
      else
        "%H:%M"
      end
      else 
        "%Y-%m-%d"
      end 
    
    time.localtime.strftime(fmt)

  end

  def mobile_device?
    #if session[:mobile_param]
    #  session[:mobile_param] == "1"
    #else
      request.user_agent =~ /Mobile|webOS/ && !(request.user_agent =~ /iPad/)
    #end
  end
  
  def mobile_host?
	request.host =~ /^m\./i
  end 
  
  def pcmode? 
    if session[:pcmode].nil? then
      !mobile_device? && !mobile_host?
    else 
      session[:pcmode]
    end
  end 
  
  def mobilemode?
    !pcmode?
  end
  
  def darkmode? 
    if session[:darkmode].nil? then
      false
    else 
      session[:darkmode]
    end
  end 

  #def mobile=(mobile)
  #  session[:mobile_param] = (mobile ? "1" : "")
  #end 
  
  def nl2br(s)
    sanitize(s, tags: []).gsub(/\r\n|\r|\n/, '<br />').html_safe
  end
  
  def pp_roles_of(user)
    str = "" 
    str += (user.superadmin? ? "- 최고관리자": "") + "\n"
    str += (user.admin? ? "- 관리자" : "") + "\n"
    str += Board.board_ids_of_my_moderating(user).map { |board_id| 
      b = Board.find(board_id)
      link_str = link_to("#{b.name} (bid: #{b.bid})", board_posts_path(b.bid))
      "- 게시판 관리자: " + link_str
    }.join("\n").to_s 
    str += "\n"
    str
  end  
  
  def delete_cache(key) 
    #logger.error "delete_cache: #{key}"
    Rails.cache.delete(key)
  end
  
  def delete_cache_if_exists(key) 
    #logger.error "delete_cache_if_exists: #{key}"
    Rails.cache.delete(key) if Rails.cache.exist?(key)
  end

  def image_url_fix_in_html(content) 
    return content if Rails.env == "development"
    #r = %r{<img(.*)src\s*=\s*['"](.*)['"]}im 
    # content.gsub(r) do |m|
      # m1, m2 = $1, $2  
      # if m2 =~ %r{^/uploads}
        # "<img#{m1}src=\"#{image_url_base}#{m2}\""
      # else
        # "<img#{m1}src=\"#{m2}\""
      # end
    # end
    r1 = %r{<img src=['"](/uploads.*?)['"]}im
    content.gsub(r1, "<img src=\"#{image_url_base}\\1\"")
  end 
  
  def image_url_fix(url) 
    return url if Rails.env == "development"
    if url =~ %r{^/uploads} then
      "#{image_url_base}#{url}"
    else 
      url 
    end 
  end 

  def print_back_trace
      begin 
        raise "######################### print_back_trace "
      rescue Exception => e 
        logger.error e.backtrace[0..10].join "\n" 
      end
      logger.error "#"*30
  end 

  def get_youtube_id(url)
    
    return nil if url.nil? 

    id = ''
    url = url.gsub(/(>|<)/i,'').split(/(vi\/|v=|\/v\/|youtu\.be\/|\/embed\/)/)
    if url[2] != nil
      id = url[2].split(/[^0-9a-z_\-]/i)
      id = id[0];
    else
      id = url;
    end
    id
  end

  def country_name(country_code)
    return "" if country_code.nil? 
    country = ISO3166::Country[country_code]
    
    return "" if country.nil? 
    country.translations[I18n.locale.to_s] || country.name
  end
  
end

