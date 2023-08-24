Rails.application.routes.draw do
  
  get 'kboard/index'
  #mount Railswiki::Engine, at: "/wiki"

  #root to: "railswiki/pages#show", id: "Home"

  #resources :menus
  root 'welcome#index'
  
  # 게시판 ============================================================

  get '/board/:bid/' => 'posts#index', as: 'board_posts', bid: /[a-zA-Z][a-zA-Z0-9_]*/ 
  get '/boards/:bid/posts' => 'posts#index'
  #get '/post/:id/' => 'posts#show', as: 'board_post'
  get '/board/:bid/:id/' => 'posts#show', as: 'board_post', bid: /[a-zA-Z][a-zA-Z0-9_]*/, id: /\d*/ 
  get '/boards/:bid/posts/new' => 'posts#new', as: 'new_board_post' 
  post '/boards/:bid/posts' => 'posts#create', as: 'create_board_post'
  get '/boards/:bid/posts/:id/edit' => 'posts#edit', as: 'edit_board_post'
  patch '/boards/:bid/posts/:id' => 'posts#update', as: 'update_board_post'
  delete '/boards/:bid/posts/:id' => 'posts#destroy', as: 'destroy_board_post'
  get '/boards/:bid/posts/:id' => 'posts#destroy', as: 'destroy_board_post2'
  get '/comments/check_new/:post_id' => 'comments#check_new', as: 'check_new_comments'
  post '/posts/:post_id/comments/:id' => 'comments#update', as: 'post_post_comment'
  get '/posts/perm_denied' => 'posts#perm_denied', as: 'perm_denied_board_post'
  
  # 그룹 최신글 
  get '/group/:bgid' => 'posts#group_index', as: 'board_group_posts', bgid: /[a-zA-Z][a-zA-Z0-9_]*/ 

  resources :posts do
    resources :comments, only: [:create, :destroy, :update, :post, :patch, :put]
  end
  
  resources :boards, only: [] do 
    resources :posts, except: [:show, :index]
  end 
  
  patch '/boards/:bid/posts/:id/favor' => "posts#favor", as: "favor_board_post", bid: /[a-zA-Z][a-zA-Z0-9_]*/, id: /[1-9][0-9]*/
  
  patch "/posts/:post_id/comments/:id/favor" => "comments#favor", as: "favor_post_comment", post_id: /[1-9][0-9]*/, id: /[1-9][0-9]*/
  post  "/posts/:post_id/comments/:id/reportabuse" => "comments#reportabuse", as: "reportabuse_post_comment", post_id: /[1-9][0-9]*/, id: /[1-9][0-9]*/
  
  resource :tinymce_assets 

  resources :fansites do
    #resources :comments, only: [:create, :destroy, :update, :post, :patch, :put]
  end

  resources :hanuris 
  #get "/hanuris/:id" => "hanuris#show", as: "hanuris_show", id: /[1-9][0-9]*/
  get "/hanuris_countries" => "hanuris#country_index", as: "hanuris_country_index_all"
  get "/hanuris_countries/:id" => "hanuris#country_index", as: "hanuris_country_index", id: /[a-zA-Z]*/

  get '/kboard', to:'kboard#index'
  
  # User ============================================================

  #devise_for :users, ActiveAdmin::Devise.config
  #devise_for :admin_users, ActiveAdmin::Devise.config
  #ActiveAdmin.routes(self)

  #devise_scope :user do
    #get "/sign_in" => "devise/sessions#new" # custom path to login/sign_in
    #get "/sign_up" => "devise/registrations#new", as: "new_user_registration" # custom path to sign_up/registration
  #end

  #devise_for :users

  devise_for :users, 
    path: 'users', 
    path_names: {
      sign_in: 'login', sign_out: 'logout', password: 'password', 
      confirmation: 'verification', unlock: 'unblock', 
      registration: 'register', sign_up: 'sign_up',
    }, 
    controllers: {
      confirmations: 'auth/confirmations',
      passwords: 'auth/passwords',
      sessions: 'auth/sessions', 
      registrations: 'auth/registrations',
      unlocks: 'auth/unlocks',
      omniauth_callbacks: 'auth/omniauth_callbacks',
    }
  
  #devise_for :users, :controllers => { omniauth_callbacks: 'user/omniauth_callbacks'}
  
  devise_scope :user do 
    post 'users/auth/check_nick_uniq' => 'auth/registrations#check_nick_uniq'
    #get  'users/auth/register_info1' => 'auth/registrations#register_info1'
    #post 'users/auth/register_info1' => 'auth/registrations#register_info1_update'
  end

  get 'profile/info' => 'profile#info_show'
  get 'profile/info/edit' => 'profile#info_edit'
  patch 'profile/info' => 'profile#info_update'
  
  namespace :profile do 
    get :scraps
    get :posts
    get :comments
    get :favorites
  end
  
  #post "/upload_image" => "upload#upload_image", :as => :upload_image
  #get "/download_file/:name" => "upload#access_file", :as => :upload_access_file, :name => /.*/ 

  # 관리자 페이지 ============================================================

  get 'admin' => 'admin#index'#, controller: :admin, action: :index 

  namespace :admin do
    
    get 'dashboard/index'

    resources :general
    
    resources :board_groups
    
    resources :boards
    post 'boards/proc' => 'boards#proc'
    
    resources :posts, only:[:index]
    post 'posts/proc' => 'posts#proc'
    
    resources :user_groups
    
    resources :users
    post 'users/proc' => 'users#proc'
    
    resources :menus
    
    resources :sites
    
    resources :levels
    #resources 'menu', only: [:index, :new, :edit, :update]
    
    resources :basicinfo, only: [:index, :edit, :update]
    
    #get 'setting/index/:front', constraints: { front: /[[:alnum:]]+/ }
    #get "setting/" => "setting#index"
    #get "setting/edit/:front" => 'setting#edit', front: /[a-zA-Z][a-zA-Z0-9_]*/ 
    #patch "setting/edit/:front" => 'setting#update', front: /[a-zA-Z][a-zA-Z0-9_]*/ 
    
    ###, constraints: { front: /[[:alnum:]]+/ }
    
    #get 'user_logs/index'
    
    resources :user_logs 
    
    resources :point_logs 

    #resources :settings
    
    namespace :settings do
      # resources :post_types
      # resources :custom_fields do
        # collection do
          # post 'get_items/:key', action: :get_items, as: :get_items
          # post "reorder"
          # get "list"
        # end
      # end
      get 'site'
      patch 'site_saved'
      #get 'test_email'
      #get 'theme'
      #post 'save_theme'
      #get "languages"
      #get "shortcodes"
      #post "languages" => :save_languages

      resources :sites
    end
    
    namespace :themes do 
      get 'theme'
      patch 'theme_saved'
    end

    get 'new_menus' => 'new_menus#index'

    
  end

  #mount RailsAdmin::Engine => '/radmin', as: 'rails_admin'


  # 고정 페이지 ===============================================================
  get "/pages/*id" => 'pages#show', as: :pages_page, format: false
  get "/*id" => 'pages#show', as: :page, format: false

  # static pages 
  #resources :high_scores
  
end
