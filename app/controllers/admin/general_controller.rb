class Admin::GeneralController < Admin::AdminController
  
  def index 
    redirect_to action: :edit, id: 'general'
  end 

  def edit
    id = params[:id]
    render "edit-#{id}"
  end

end
