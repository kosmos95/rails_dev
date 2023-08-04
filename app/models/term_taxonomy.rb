class UniqValidator < ActiveModel::Validator
  def validate(record)
    unless record.skip_slug_validation?
      record.errors[:base] << "#{I18n.t('camaleon_cms.admin.post.message.requires_different_slug')}" if ::TermTaxonomy.where(slug: record.slug).where.not(id: record.id).where("#{TermTaxonomy.table_name}.taxonomy" => record.taxonomy).where("#{TermTaxonomy.table_name}.parent_id" => record.parent_id).size > 0
    end
  end
end

class TermTaxonomy < ApplicationRecord

  include Metas
  self.table_name = "term_taxonomy"

    # callbacks
  before_validation :before_validating
  before_destroy :destroy_dependencies

  # validates
  validates :name, :taxonomy, presence: true
  validates_with UniqValidator

  # relations
  has_many :term_relationships, :class_name => "TermRelationship", :foreign_key => :term_taxonomy_id, dependent: :destroy
  belongs_to :parent, class_name: "TermTaxonomy", foreign_key: :parent_id, optional: true
  
  def skip_slug_validation?
    false
  end
  
  private
  
    # callback before validating
    def before_validating
      slug = self.slug
      slug = self.name if slug.blank?
      self.name = slug unless self.name.present?
      self.slug = slug.to_s.parameterize.try(:downcase)
    end

    # destroy all dependencies
    # unassign all items from menus
    def destroy_dependencies
      #in_nav_menu_items.destroy_all
    end

end
