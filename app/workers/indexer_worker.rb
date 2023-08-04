class IndexerWorker
  include Sidekiq::Worker
  
  sidekiq_options queue: 'elasticsearch', retry: false

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil

  Client =  ApplicationRecord.default_elasticsearch_client

  def perform(operation, record_id)
    
    logger.info [operation, "ID: #{record_id}"]

    case operation.to_s
    when /index/
      begin
        record = Post.find(record_id)
        # https://www.rubydoc.info/gems/elasticsearch-model/Elasticsearch/Model/Indexing/InstanceMethods#update_document-instance_method
        #record.__elasticsearch__.index_document         
        Client.index index: Post.index_name, type: Post.document_type, id: record.id, body: record.as_indexed_json
      rescue ActiveRecord::RecordNotFound => e; 
        logger.debug e 
      end
      
    when /update/
      begin
        record = Post.find(record_id)
        
        #https://www.rubydoc.info/gems/elasticsearch-model/Elasticsearch/Model/Indexing/InstanceMethods#update_document-instance_method
        record.__elasticsearch__.update_document_attributes record.as_indexed_json
        
        # https://github.com/elastic/elasticsearch-py/issues/649 
        #Client.update index: Post.index_name, type: Post.document_type, id: record.id, body: { :doc => record.__elasticsearch__.as_indexed_json }        
        #Client.update id:record_id, body: { :doc => record.as_indexed_json }        
      rescue ActiveRecord::RecordNotFound => e; 
        logger.debug e 
      end
      
    # when /upsert/
      # begin
        # record = Post.find(record_id)
        
        # #https://www.rubydoc.info/gems/elasticsearch-model/Elasticsearch/Model/Indexing/InstanceMethods#update_document-instance_method
        # #record.__elasticsearch__.update_document_attributes record.as_indexed_json
        
        # # https://github.com/elastic/elasticsearch-py/issues/649 
        # Client.update index: Post.index_name, type: Post.document_type, id: record.id, body: { :upsert => record.as_indexed_json }
        # #Client.update id:record_id, body: { :doc => record.as_indexed_json }        
      # rescue ActiveRecord::RecordNotFound => e; 
        # logger.debug e 
      # end      

    when /delete/
      begin      
        Client.delete index: Post.index_name, type: Post.document_type, id: record_id        
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        logger.info "Post not found, ID: #{record_id}"
      end
      
    else 
      raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
  
end
