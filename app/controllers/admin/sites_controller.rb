class Admin::SitesController < Admin::AdminController
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  before_action :check_shared_status
  #add_breadcrumb I18n.t("camaleon_cms.admin.sidebar.sites"), :cama_admin_settings_sites_path

  def index
    @sites = Site.all.order(:id)
    @sites = @sites.paginate(:page => params[:page], :per_page => 15)
    r = { sites: @sites, render: "index" }
    #hooks_run("list_site", r)
    render r[:render] 
  end

  def show
  end

  def edit
    #add_breadcrumb I18n.t("camaleon_cms.admin.button.edit")
    #render 'form'
  end

  def update
    tmp = @site.slug
    if @site.update(params.require(:site).permit!)
      save_metas(@site)
      flash[:notice] = t('camaleon_cms.admin.sites.message.updated')
      if @site.id == Site.main_site.id && tmp != @site.slug
        redirect_to @site.the_admin_url
      else
        redirect_to action: :index
      end
    else
      edit
    end
  end

  def new
    #add_breadcrumb I18n.t("camaleon_cms.admin.button.new")
    @site ||= Site.new.decorate
    render 'new'
  end

  def create
    site_data = params.require(:site).permit!
    @site = CamaleonCms::Site.new(site_data)
    if @site.save
      save_metas(@site)
      site_after_install(@site, @site.get_theme_slug)
      flash[:notice] = t('camaleon_cms.admin.sites.message.created')
      redirect_to action: :index
    else
      new
    end
  end

  def destroy
    flash[:notice] = t('camaleon_cms.admin.sites.message.deleted') if @site.destroy
    redirect_to action: :index
  end

  private

    def save_metas(site)
      if params[:metas].present?
        params[:metas].each do |meta, val|
          site.set_meta(meta, val)
        end
      end
    end

    def set_site
      begin
        @site = Site.find_by_id(params[:id]).decorate
      rescue
        flash[:error] = t('camaleon_cms.admin.sites.message.error')
        redirect_to admin_path
      end
    end

    # check if the system.config manage shared users
    def check_shared_status
      unless current_site.manage_sites?
        flash[:error] = t('camaleon_cms.admin.sites.message.unauthorized')
        redirect_to admin_path
      end
    end
  
end
