class Admin::MenusController < Admin::AdminController
  before_action :set_menu, only: [:show, :edit, :update, :destroy]

  # GET /menus
  # GET /menus.json
  def index
    @menus = Menu.all
  end

  # GET /menus/1
  # GET /menus/1.json
  def show
  end

  # GET /menus/new
  def new
    @menu = Menu.new
    @sites = Site.all 
	#@menu.content = YamlMenu.yaml
  end

  # GET /menus/1/edit
  def edit
    @sites = Site.all   
  end

  # POST /menus
  # POST /menus.json
  def create
  #pp menu_params
    @menu = Menu.new(menu_params)
    @sites = Site.all

    respond_to do |format|
      if @menu.save
        
        Rails.cache.write("menu:#{@menu.name}", @menu.content)
        
        format.html { redirect_to [:admin, @menu], notice: 'Menu was successfully created.' }
        format.json { render :show, status: :created, location: @menu }
      else
        format.html { render :new }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update
    respond_to do |format|
      if @menu.update(menu_params)
      
        Rails.cache.write("menu:#{@menu.name}", @menu.content)
        
        format.html { redirect_to [:admin, @menu], notice: 'Menu was successfully updated.' }
        format.json { render :show, status: :ok, location: @menu }
      else
        format.html { render :edit }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    @menu.destroy
    respond_to do |format|
      format.html { redirect_to admin_menus_url, notice: 'Menu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      @menu = Menu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def menu_params
      params.require(:menu).permit(:site_id, :name, :content)
    end
end
