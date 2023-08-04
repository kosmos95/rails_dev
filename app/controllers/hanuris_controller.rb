class HanurisController < ApplicationController

  include SanitizeUrlHelper
  include HanurisHelper 

  before_action :initdata 
  before_action :set_hanuri, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!, except: [:country_index, :index, :group_index, :show]
  #before_action :authenticate_user!
  
  # cancancan으로 posts의 authorization을 처리하겠다는 의미
  load_and_authorize_resource
  
  # GET /hanuris
  # GET /hanuris.json
  def index
    
    @page = (params[:page] || '1').to_i
    @page = 0 if @page < 0 
    
    @lang = params[:lang] || 'EN' 
    @lang = 'EN' unless ['KO', 'EN'].include?(@lang)
    @starts_with = params[:starts_with] || ''
    
    @country = params[:country] || ""
    
    #@regions = ['Africa', 'Europe', 'Americas', 'Asia', 'Oceania']
    if @country != ''
      @countries_idx = ISO3166::Country.translations(@lang).filter { |x, y| x == @country }
    else 
      if @starts_with != '' 
        if @lang == 'EN' 
          @countries_idx = ISO3166::Country.translations(@lang).filter { |x, y| y =~ %r{^#{@starts_with}} }.sort { |x, y| x[1] <=> y[1] }
        else 
          next_ch = next_kor_char_of(@starts_with)
          if !next_ch.nil? 
            @countries_idx = ISO3166::Country.translations(@lang).filter { |x, y| (y >= @starts_with && y < next_ch) }.sort { |x, y| x[1] <=> y[1] }
          else 
            @countries_idx = []
          end 
        end 
      else 
        @countries_idx = ISO3166::Country.translations(@lang)
      end 
    end 
    
    @country_idx_keys = @countries_idx.map { |x| x[0] }
    
    @recnum = 10
    WillPaginate.per_page = @recnum
    
    if can? :edit, Hanuri then  # 관리자 
      q = Hanuri.in_country(@country_idx_keys).order('id desc')
      @total_count = Hanuri.in_country(@country_idx_keys).count
    else 
      q = Hanuri.in_country(@country_idx_keys).exclude_hidden.order('id desc')
      @total_count = Hanuri.in_country(@country_idx_keys).exclude_hidden.count
    end 
    
    @hanuris = q.paginate(:page => @page, :per_page => @recnum, :total_entries => @total_count)
    
  end
  
  def country_index 
    
    #@lang = params[:lang] || 'EN' 
    #@starts_with = params[:starts_with] || ''
    
    # @page = (params[:page] || '1').to_i
    # @recnum = 10

    # #@countries = country_starting_with(@starts_with, @lang)
    
    # @total_count =  @flag_countries.count 
    # paged_flag_countries = @flag_countries.paginate(:page => @page, :per_page => @recnum)
    
    # @country_keys = WillPaginate::Collection.create(@page, @recnum) do |pager|
      # pager.replace(paged_flag_countries)
      # #unless pager.total_entries
        # pager.total_entries = @total_count
      # #end
    # end
    
    #  
    
    @regions = ['Africa', 'Europe', 'Americas', 'Asia', 'Oceania']
    @countries_by_region = Hash.new 
    @regions.each do |x|
      @countries_by_region[x] = ISO3166::Country.find_all_by(:region, x).sort { |x,y| 
        x[1]['translations']['ko'] <=> y[1]['translations']['ko'] }.map { |x| x[0] }
    end
    
  end

  # GET /hanuris/1
  # GET /hanuris/1.json
  def show
  end

  # GET /hanuris/new
  def new
    @hanuri = Hanuri.new
    @country = params[:country]
  end

  # GET /hanuris/1/edit
  def edit
  end

  # POST /hanuris
  # POST /hanuris.json
  def create
    @hanuri = Hanuri.new(hanuri_params)
    
    if @hanuri.user_id.nil? 
      @hanuri.user_id = current_user.id
    end 

    respond_to do |format|
      if @hanuri.save
        format.html { redirect_to @hanuri, country: @hanuri[:country], notice: 'Hanuri was successfully created.' }
        format.json { render :show, status: :created, location: @hanuri }
      else
        format.html { render :new }
        format.json { render json: @hanuri.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hanuris/1
  # PATCH/PUT /hanuris/1.json
  def update
    respond_to do |format|
      if @hanuri.update(hanuri_params)
        format.html { redirect_to @hanuri, notice: 'Hanuri was successfully updated.' }
        format.json { render :show, status: :ok, location: @hanuri }
      else
        format.html { render :edit }
        format.json { render json: @hanuri.errors, status: :unprocessable_entity }
      end
    end
  end

  
    # def info_update 
    # @user = current_user 
    # @userdata = @user.data
    
    # respond_to do |format|
      # if @user.update(profile_params_user) && @userdata.update(profile_params)
        # #format.html { render :info_edit, notice: '회원정보가 수정되었습니다.' }
        # format.html { redirect_to profile_info_path, notice: t('hcafe2.profile.modified') }
        # #format.json { render :show, status: :ok, location: @post }
      # else
        # #@user = current_user 
        # #@userdata = @user.data
      
        # #format.html { render "posts/#{@skin}/edit" }
        # #format.json { render json: @post.errors, status: :unprocessable_entity }
        
        # format.html { render "profile/info_edit" }
        # #format.json { render json: @userdata.errors, status: :unprocessable_entity }        
      # end
    # end
    
  # end  
  
  # DELETE /hanuris/1
  # DELETE /hanuris/1.json
  def destroy
    @hanuri.destroy
    respond_to do |format|
      format.html { redirect_to hanuris_url, notice: 'Hanuri was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hanuri
      @hanuri = Hanuri.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hanuri_params
      params.require(:hanuri).permit(:title, :country, :url1, :url2, :url3, :url_info, :sns_urls, :description, :image, :hidden)
    end

    def initdata
    
      @flag_countries = %w(
        au  bn  cg  cy  eh  ge  ht  jo  kz  ly  mr  ni  ph  rw  sn  tj  ug  ye
        az  bo  ch  cz  er  gh  hu  jp  la  ma  mt  nl  pk  sa  so  tl  us  za
        ad  ba  br  ci  de  es  gm  id  ke  lb  mc  mu  no  pl  sb  sr  tm  uy  zm
        ae  bb  bs  ck  dj  et  gn  ie  kg  lc  md  mv  np  ps  sc  ss  tn  uz  zw
        af  bd  bt  cl  dk  fi  gq  il  kh  li  me  mw  nr  pt  sd  st  to  va
        ag  be  bw  cm  dm  fj  gr  in  ki  lk  mg  mx  nu  pw  se  sv  tr  vc
        al  bf  by  cn  do  fm  gt  iq  km  lr  mh  my  nz  py  sg  sy  tt  ve
        am  bg  bz  co  dz  fr  gw  ir  kn  ls  mk  mz  om  qa  si  sz  tv  vn
        ao  bh  ca  cr  ec  ga  gy  is  kp  lt  ml  na  pa  ro  sk  td  tw  vu
        ar  bi  cd  cu  ee  gb  hn  it  kr  lu  mm  ne  pe  rs  sl  tg  tz  ws
        at  bj  cf  cv  eg  gd  hr  jm  kw  lv  mn  ng  pg  ru  sm  th  ua  xk).sort
        
    end 
    
end
