module SitesHelper

  def current_site(site = nil)
    @current_site = site.decorate if site.present?
    return $current_site if defined?($current_site)
    return @current_site if defined?(@current_site)
    #if PluginRoutes.get_sites.size == 1
      site = Site.first.decorate rescue nil
    #else
      #host = [request.original_url.to_s.parse_domain]
      #host << request.subdomain if request.subdomain.present?
      #site = CamaleonCms::Site.where(slug: host).first.decorate rescue nil
    #end
    r = {site: site, request: (request rescue nil)};
    #cama_current_site_helper(r) rescue nil
    if !r[:site].present?
      Rails.logger.error 'HCafe2 - Please define your current site: $current_site = Site.first.decorate or map your domains: http://camaleon.tuzitio.com/documentation/category/139779-examples/how.html' 
    end 
    @current_site = r[:site]
  end
  
end
