class Site < TermTaxonomy
  include Metas

  default_scope { where(taxonomy: :site) }
  
  attr_accessor :site_domain

  has_many :menus 
  has_many :themes, :class_name => "Theme", foreign_key: :parent_id, dependent: :destroy
  
  before_validation :before_validation
  before_save :before_save
  
  def self.main_site
    @main_site ||= Site.reorder(id: :asc).first
  end

  # check if this site is the main site
  # main site is a site that doesn't have slug
  def main_site?
    self.class.main_site == self
  end
  alias_method :is_default?, :main_site?
  
  # return the domain for current site
  # sample: mysite.com | sample.mysite.com
  # also, you can define custom domain for this site by: my_site.site_domain = 'my_site.com' # used for sites with different domains to call from console or task
  def get_domain
    @site_domain || (main_site? ? slug : (slug.include?(".") ? slug : "#{slug}.#{Site.main_site.slug}"))
  end
  
  def to_s 
    "[#{id}] #{name}"
  end
  
  def current_theme 
    @theme ||= self.themes.first
  end 
  alias_method :theme, :current_theme

  def skip_slug_validation?
    true
  end 
  
  private
  
    def before_validation 
      self.parent_id = 0
    end 
    
    def before_save
      self.taxonomy = 'site'
    end
    
end
