class ::CustomFieldsRelationship < ActiveRecord::Base
  self.table_name = "custom_fields_relationships"

  # attr_accessible :objectid, :custom_field_id, :term_order, :value, :object_class,
  # :custom_field_slug, :group_number
  default_scope { order("#{::CustomFieldsRelationship.table_name}.term_order ASC") }

  # relations
  belongs_to :custom_fields, class_name: '::CustomField', foreign_key: :custom_field_id

  # validates :objectid, :custom_field_id, presence: true
  validates :custom_field_id, presence: true # error on clone model

  after_save :set_parent_slug
  after_save :update_model_owner # TODO: convert this model into polymorphic

  private

  def set_parent_slug
    # self.update_column('custom_field_slug', self.custom_fields.slug)
  end
  
  # touch owner model
  def update_model_owner
    "::#{object_class}".constantize.find(objectid).touch rescue nil # owner model
  end
end
