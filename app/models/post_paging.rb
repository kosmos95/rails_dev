class PostPaging < ApplicationRecord

  #include PagingTableProvider 
  
  #self.primary_key = :id 
  self.table_name = "---"
  
  def self.options 
    @@paging_options[self.table_name]
  end 
  
  def self.within_table(name)
    begin
      previous_table_name = self.table_name
      self.table_name = name if name.present?
      yield if block_given?

    ensure
      self.table_name = previous_table_name
    end
  end
  
  # def with_paging(**options)
    # tablename = make_paging_table_name(options)
    # create_paging_table(options) if options[:createtable]
    # self.within_table(tablename) do 
      # yield if block_given?
    # end
    # drop_paging_table_by_tablename(tablename) if options[:droptable]
  # end 

  def self.for_table(tablename)
    class_eval "class Paging_#{tablename} < PostPaging; self.table_name='#{tablename}'; end"
    "PostPaging::Paging_#{tablename}".constantize
  end

  def self.get_paging_class(**options)
    tablename = make_paging_table_name(options)

    @@paging_classes ||= {}
    @@paging_options ||= {}
    return @@paging_classes[tablename] if @@paging_classes[tablename].present?
    
    klass = self.for_table(tablename)
    
    @@paging_classes[tablename] = klass
    @@paging_options[tablename] = options
    
    klass
  end
  
  def self.make_paging_table_name(**options)
    options[:board_id] ||= 0
    options[:board_group_id] ||= 0
    options[:orderby] ||= "gid"
    options[:recnum] ||= Post::PER_PAGE 
    options[:keyword] ||= ""
    options[:notice] ||= 0
    
    board_id = options[:board_id] 
    board_group_id = options[:board_group_id]
    orderby = options[:orderby].gsub(/\s*/, "")
    recnum = options[:recnum]
    notice = options[:notice]
    keyword = options[:keyword].strip

    tablename = "_postspaging_g#{board_group_id}_b#{board_id}_k#{keyword}_o#{orderby}_r#{recnum}_n#{notice}"
    return tablename.downcase
  end
  
  def self.id_for_page(page)
    tablename = table_name
    
    p = page.to_i - 1
    p = 0 if p <= 0
    
    Multidb.use(:slave) do 
      row = ActiveRecord::Base.connection.execute(
        "SELECT gid FROM #{tablename} limit #{p}, 1").first 
        # ORDER BY num
      return row.nil? ? 0 : row[0]
    end 
    
    return 0
  end 
  
  def self.empty?    
    tablename = table_name
    
    Multidb.use(:slave) do 
      row = ActiveRecord::Base.connection.execute(
        "SELECT gid FROM #{tablename} limit 0, 1").first 
        # ORDER BY num
      row.nil?
    end    
  end 
  
  def self.create_paging_table
    create_paging_table_by_tablename(self.table_name, self.options)
  end 
  
  def self.create_paging_table_by_tablename(tablename, **options)
    
    #$lock ||= MemcacheLock.new(Rails.cache)

    #$lock.synchronize("PostPaging::create_paging_table_by_tablename/#{tablename}") do
      _really_drop_paging_table_by_tablename(tablename, options)
      _really_create_paging_table_by_tablename(tablename, options)
    #end
    
  end
  
  def self.drop_paging_table
    drop_paging_table_by_tablename(self.table_name, self.options)
  end 
  
  def self.drop_paging_table_by_tablename(tablename, **options)
  
    #$lock ||= MemcacheLock.new(Rails.cache)

    #$lock.synchronize("PostPaging::drop_paging_table_by_tablename/#{tablename}") do
      _really_drop_paging_table_by_tablename(tablename, options)
    #end
    
  end 

  private 
  
    def self._really_create_paging_table_by_tablename(tablename, **options) 
    
      #options[:board_id] ||= nil
      #options[:board_group_id] ||= nil
      options[:orderby] ||= "gid"
      options[:recnum] ||= Post::PER_PAGE
      options[:call_droptable] = false if options[:call_droptable].nil? 
      options[:notice] ||= 0
      options[:use_momorydb] = true if options[:use_momorydb].nil? 

      board_id = options[:board_id]
      board_group_id = options[:board_group_id]
      orderby = options[:orderby]
      recnum = options[:recnum]
      notice = options[:notice]
      use_momorydb = options[:use_momorydb] ? "ENGINE=MEMORY" : ""
      
      #, p.id, p.board_id, p.board_group_id 
      sql = %Q{
        CREATE TABLE `#{tablename}` #{use_momorydb}
        SELECT gid 
        FROM (
          SELECT CAST(@row := @row + 1 AS INTEGER) AS num, p.gid as gid 
          FROM (SELECT @row := 0) r, posts p 
          WHERE 1 }

      sql += %Q{AND p.board_id = '#{board_id}' } unless board_id.nil?
      
      sql += %Q{AND p.board_group_id = '#{board_group_id}' } unless board_group_id.nil?
      
      sql += %Q{AND p.notice = '#{notice}' } unless notice.nil?
      
      sql += %{
          ORDER BY #{orderby}
        ) ranked
        
        WHERE num % #{recnum} = 1;
      }

      # mermoy db 이므로 삭제되었을 경우 확인을 위해 1줄을 추가로 추가해줌. 
      sql2 = %Q{
        INSERT INTO `#{tablename}` ( gid ) values ( 0 );
      }
      
      Multidb.use(:master) do 
        ActiveRecord::Base.connection.execute(sql)
        ActiveRecord::Base.connection.execute(sql2)
      end 
      
      # sql = %Q{
        # CREATE INDEX num_idx ON #{tablename}(num);
      # }
      
      # ActiveRecord::Base.connection.execute(sql)  
    end 
    
    def self._really_drop_paging_table_by_tablename(tablename, **options)
    
      options[:use_temp_table] ||= false
      #temporary = options[:use_temp_table] ? "TEMPORARY" : ""

      sql = %Q{
        DROP TABLE IF EXISTS `#{tablename}`
      }

      #logger.info "drop_paging_table_by_tablename: #{sql}"

      Multidb.use(:master) do 
        ActiveRecord::Base.connection.execute(sql)
      end 
      
    end 
      
end
