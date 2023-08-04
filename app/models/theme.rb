class Theme < TermTaxonomy

  include Metas

  belongs_to :site, class_name: "Site", foreign_key: :parent_id
  default_scope { where(taxonomy: :theme) }

  before_validation :fix_name
  before_save :before_save
  
  private
  
    def before_save
      self.taxonomy = 'theme'
    end
    
    def fix_name
      self.name = self.slug unless self.name.present?
    end
  
end
