class Admin::PointLogsController < Admin::AdminController

  def index
  
    do_index_actions() 
    
  end
  
  
  private 
  
    def do_index_actions 

      @recnum = params[:recnum].present? ? params[:recnum].to_i : 15 
      @where = params[:where] || 'nick'
      @page = params[:page].present? ? params[:page].to_i : 1
      @keyword = params[:keyword] || ''
      @sort = params[:sort] || "reason"
      @orderby = params[:orderby] || "desc"

      where_list = %w(name nick email reason)
      
      where_str = "1 "

      where1 = where_list.include?(params[:where]) ? params[:where] : 'nick'
      where_str += "AND (#{where1} like '%#{@keyword}%')" if @keyword != ''

      @total_count = PointLog.joins(:user).where(where_str).count 
      @total_page_num = @total_count / @recnum + 1 
      @point_logs = PointLog.joins(:user).where("#{where_str} ").order("#{@sort} #{@orderby}")
        .paginate(:page => @page, :per_page => @recnum, :total_entries => @total_count)
        
    end 
      
end
