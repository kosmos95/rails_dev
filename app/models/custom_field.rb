class CustomField < ActiveRecord::Base
  include Metas

  self.primary_key = :id
  self.table_name = "custom_fields"

  alias_attribute :label, :name

  default_scope { order("#{CustomField.table_name}.field_order ASC") }
  #scope :configuration, -> { where(parent_id: -1) }
  scope :visible_group, -> { where(status: nil) }

  # status: nil -> visible on list group fields
  # attr_accessible :object_class, :objectid, :description, :parent_id, :count, :name, :slug,
  # :field_order, :status, :is_repeat
  has_many :metas, -> { where(object_class: 'CustomField') }, class_name: '::Meta',
    foreign_key: :objectid, dependent: :destroy
  has_many :values, class_name: '::CustomFieldsRelationship',
    foreign_key: :custom_field_id, dependent: :destroy
  belongs_to :custom_field_group, class_name: '::CustomFieldGroup'
  belongs_to :parent, class_name: '::CustomField', foreign_key: :parent_id

  validates :name, :object_class, presence: true
  validates_uniqueness_of :slug, scope: [:parent_id, :object_class],
    unless: ->(o) { o.is_a?(::CustomFieldGroup) }

  before_validation :before_validating

  private

  def before_validating
    self.slug = name if slug.blank?
    self.slug = self.slug.to_s.parameterize
  end
end
