class Admin::BoardPostsController < ApplicationController

  #before_action :set_board_group, only: [:show, :edit, :update, :destroy]

  # GET /board_groups
  # GET /board_groups.json
  def index
    @board_posts = Post.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board_group
      #@board_group = BoardGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def board_group_params
      params.require(:board_group).permit(:bgid, :name)
    end
    
end
