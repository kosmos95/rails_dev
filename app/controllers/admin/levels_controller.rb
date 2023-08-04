class Admin::LevelsController < Admin::AdminController

  before_action :set_level, only: [:show, :edit, :update, :destroy]

  before_action :init_data, only: [:index]

  # GET /levels
  # GET /levels.json
  def index
    @sites = Site.all 
    @levels = Level.all 
  end

  # GET /levels/1
  # GET /levels/1.json
  def show
  end

  # GET /levels/new
  def new
    @level = Level.new
  end

  # GET /levels/1/edit
  def edit
  end

  # POST /levels
  # POST /levels.json
  def create
    @level = Level.new(level_params)

    respond_to do |format|
      if @level.save
        format.html { redirect_to admin_levels_url, notice: '레벨이 만들어졌습니다.' }
        format.json { render :show, status: :created, location: @level }
      else
        format.html { render :new }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /levels/1
  # PATCH/PUT /levels/1.json
  def update
    respond_to do |format|
      if @level.update(level_params)
        format.html { redirect_to admin_levels_url, notice: '변경되었습니다.' }
        format.json { render :show, status: :ok, location: @level }
      else
        format.html { render :edit }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /levels/1
  # DELETE /levels/1.json
  def destroy
    @level.destroy
    respond_to do |format|
      format.html { redirect_to admin_levels_url, notice: '레벨이 삭제되었습니다.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_level
      @level = Level.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def level_params
    
      params.fetch(:level, {})
        .permit(:level, :name, :enable_autoupgrade, :autoupgrade_login_num, :autoupgrade_post_num, :autoupgrade_comment_num, :autoupgrade_visit_days)
      
      #params.require(:level)
    end
    
    def init_data 
      levels = Level.all       
      Level::init_levels if levels.size == 0 
    end 
    
end
