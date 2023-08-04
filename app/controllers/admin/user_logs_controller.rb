class Admin::UserLogsController < Admin::AdminController

  def index
  
    do_index_actions() 
    
  end
  

  private 
  
    def do_index_actions 

      @recnum = params[:recnum].present? ? params[:recnum].to_i : 15 
      @where = params[:where] || 'event_name'
      @page = params[:page].present? ? params[:page].to_i : 1
      @keyword = params[:keyword] || ''
      @sort = params[:sort] || "id"
      @orderby = params[:orderby] || "desc"

      where_list = %w(name nick email ip event_name)
      
      where_str = "1 "

      where1 = where_list.include?(params[:where]) ? params[:where] : 'event_name'
      where_str += "AND (#{where1} like '%#{@keyword}%')" if @keyword != ''
      
      @total_count = UserLog.joins(:user).where(where_str).count 
      @total_page_num = @total_count / @recnum + 1 
      @user_logs = UserLog.joins(:user).where("#{where_str} ").order("#{@sort} #{@orderby}")
        .paginate(:page => @page, :per_page => @recnum, :total_entries => @total_count)
        
    end 
      
end
