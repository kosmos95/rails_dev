class Admin::BoardGroupsController < Admin::AdminController
  
  before_action :set_board_group, only: [:show, :edit, :update, :destroy]

  # GET /board_groups
  # GET /board_groups.json
  def index
    @board_groups = BoardGroup.all
  end

  # GET /board_groups/1
  # GET /board_groups/1.json
  def show
  end

  # GET /board_groups/new
  def new
    @board_group = BoardGroup.new
  end

  # GET /board_groups/1/edit
  def edit
  end

  # POST /board_groups
  # POST /board_groups.json
  def create
    @board_group = BoardGroup.new(board_group_params)

    respond_to do |format|
      if @board_group.save
        format.html { redirect_to url:[:admin, @board_group], notice: 'Board group was successfully created.' }
        format.json { render :show, status: :created, location: @board_group }
      else
        format.html { render :new }
        format.json { render json: @board_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /board_groups/1
  # PATCH/PUT /board_groups/1.json
  def update
    respond_to do |format|
      if @board_group.update(board_group_params)
        format.html { redirect_to url:[:admin, @board_group], notice: 'Board group was successfully updated.' }
        format.json { render :show, status: :ok, location: @board_group }
      else
        format.html { render :edit }
        format.json { render json: @board_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /board_groups/1
  # DELETE /board_groups/1.json
  def destroy
    @board_group.destroy
    respond_to do |format|
      format.html { redirect_to admin_board_groups_path, notice: 'Board group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board_group
      @board_group = BoardGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def board_group_params
      params.require(:board_group).permit(:bgid, :name, :board_group_id)
    end
end
