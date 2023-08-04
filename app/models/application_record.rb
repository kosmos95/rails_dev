class ApplicationRecord < ActiveRecord::Base
  
  include FunctionsHelper
  include MultidbHelper 
  
  self.abstract_class = true

  #Elasticsearch::Model.client ||= Elasticsearch::Client.new host: Setting.elasticsearch_server, log: true
  
  #def self.table_name_prefix
  #  'hc_'
  #end

  def delete_cache(key) 
    #logger.error "delete_cache: #{key}"
    Rails.cache.delete(key)
  end
  
  def delete_cache_if_exists(key) 
    #logger.error "delete_cache_if_exists: #{key}"
    Rails.cache.delete(key) if Rails.cache.exist?(key)
  end
  
  def self.default_elasticsearch_client 
    
    logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil

    #elastic_host = '10.3.0.9:81'
    elastic_host = ENV.fetch("ELASTICSEARCH_SERVER_HOST") { "127.0.0.1:9200" }

    @@elasticsearch_client ||= 
        if Rails.env == 'production' then 
          Elasticsearch::Client.new host: elastic_host, logger: logger 
        else 
          Elasticsearch::Client.new logger: logger  
        end 
  end 
    
end
