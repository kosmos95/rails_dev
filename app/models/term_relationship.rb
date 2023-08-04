class TermRelationship < ApplicationRecord

  default_scope ->{ order(term_order: :asc) }

  belongs_to :term_taxonomies, :class_name => "TermTaxonomy", foreign_key: :term_taxonomy_id, inverse_of: :term_relationships
  
  #belongs_to :objects, ->{ order("#{Post.table_name}.id DESC") }, :class_name => "Post", foreign_key: :objectid, inverse_of: :term_relationships

end
