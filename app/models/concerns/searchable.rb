module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    mapping do
      # ...
    end

    def self.search(query)
      # ...
    end
  end
end

################################
# require 'active_record'
# ActiveRecord::Base.establish_connection( adapter: 'sqlite3', database: ":memory:" )
# ActiveRecord::Schema.define(version: 1) { create_table(:articles) { |t| t.string :title } }

# class Article < ActiveRecord::Base; end

# Article.create title: 'Quick brown fox'
# Article.create title: 'Fast black dogs'
# Article.create title: 'Swift green frogs'

################################
# In: app/models/article.rb
#
# class Article
  # include Searchable
# end

################################


