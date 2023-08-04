class PostIndex < ApplicationRecord

  self.primary_key = :post_id
  
  #######################################
  # relations 
  belongs_to :post
  
  # addition 
  belongs_to :board   
  belongs_to :user 

  # def with_post_paging(**options)
    # # options[:board_id] ||= nil
    # # options[:board_group_id] ||= nil
    # # options[:orderby] ||= "gid desc"
    # # options[:rownum] ||= 20
    # options[:droptable] = true 
    # PostPaging.create_paging_table("paging", options)
  # end

  # for widgete 
  def self.recent_post_indices(**options)
    # options: board_id, board_group_id, site_id, order, recnum 
    options[:recnum] ||= 7
    options[:recnum] = 100 if options[:recnum] > 100 
    options[:recnum] = 1 if options[:recnum] <= 0    
    
    options[:order] ||= :gid 
    options[:order] = :gid if options[:order].nil?

    query = PostIndex.where("1") 
    query = query.where("board_id = ?", options[:board_id]) if !options[:board_id].nil? 
    query = query.where("board_group_id = ?", options[:board_group_id]) if !options[:board_group_id].nil?
    query = query.where("site_id = ?", options[:site_id]) if !options[:site_id].nil? 
    query = query.order(options[:order]) 
      .limit(options[:recnum])
      
    query
  end 

  # for paging table 
  
  def create_paging_table_by_tablename(tablename, **options)
    
    drop_paging_table_by_tablename(tablename)
    
    options[:board_id] ||= nil
    options[:board_group_id] ||= nil
    options[:orderby] ||= "gid desc"
    options[:recnum] ||= 20
    options[:call_droptable] ||= false
    options[:notice] ||= 0

    board_id = options[:board_id]
    board_group_id = options[:board_group_id]
    orderby = options[:orderby]
    recnum = options[:recnum]
    
    sql = %Q{
      CREATE TEMPORARY TABLE `#{tablename}`
      SELECT *
      FROM (
        SELECT @row := @row + 1 AS recnum, p.id, p.gid, p.board_id, p.board_group_id
        FROM (SELECT @row := 0) r, posts p 
        WHERE 1 }

    sql += %Q{AND p.board_id = "#{board_id}" } unless board_id.nil?
    
    sql += %Q{AND p.board_group_id = "#{board_group_id}" } unless board_group_id.nil?
    
    sql += %Q{AND p.notice = "#{notice}" } unless notice.nil?
    
    sql += %{
        ORDER BY #{orderby}
      ) ranked
      
      WHERE recnum % #{recnum} = 1;
    }
    
    ActiveRecord::Base.connection.execute(sql)
    
    sql = %Q{
      CREATE INDEX recnum_idx ON #{tablename}(recnum);
    }
    
    ActiveRecord::Base.connection.execute(sql)
    
  end   
  
  def drop_paging_table_by_tablename(tablename)
    sql = %Q{
      DROP TEMPORARY TABLE IF EXISTS `#{tablename}`
    }
    ActiveRecord::Base.connection.execute(sql)
  end 
  

end
