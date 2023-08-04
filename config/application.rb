require_relative 'boot'

require 'rails/all'

# my library 
#require_relative '../lib/cached_data'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hcafe2
  class Application < Rails::Application
  
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.autoloader = :zeitwerk 

    # autoload path 
    config.autoload_paths += [ 
      "#{Rails.root}/app/widgets",
    ]
    
    config.eager_load_paths += [
      "#{Rails.root}/app/lib"
    ]

    config.eager_load = true 
    
    #Dir[File.join(Rails.root, "app", "lib", "ext", "**", "*.rb")].each{ |f| require f }
    
    #config.paths.add Rails.root.join('app', 'lib').to_s, eager_load: true

    #config.eager_load_paths << Rails.root.join('app', 'lib', 'will_paginate', 'lib')
    #config.autoload_paths << Rails.root.join('app', 'lib', 'will_paginate', 'lib')


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
	
	  #config.time_zone = 'Asia/Seoul'
	
    # config/application.rb
    #config.exception_handler = {
      # Old (still works)
      # No "all" / "4xx"/"5xx" options
      # layouts: {
      #   500 => 'exception',
      #   501 => 'exception'
      # },

      # # New
      # exceptions: {
      #   :all => { layout: 'exception' },
      #   #:404 => { layout: 'exception' },
      #   #:5xx => { layout: 'exception' }, # -> this overrides the :all declaration
      #   #500  => { layout: nil } # -> this overrides the 5xx declaration
      # }
    #}
    
    #config.consider_all_requests_local = false 
    
    config.exception_handler = {
  
      dev:        false, # allows you to turn ExceptionHandler "on" in development
      db:         nil, # allocates a "table name" into which exceptions are saved (defaults to nil)
      email:      nil, # sends exception emails to a listed email (string // "you@email.com")

      # Custom Exceptions
      custom_exceptions: {
        #'ActionController::RoutingError' => :not_found # => example
      },

      # On default 5xx error page, social media links included
      social: {        
        facebook: nil, # Facebook page name   
        twitter:  nil, # Twitter handle  
        youtube:  nil, # Youtube channel name / ID
        linkedin: nil, # LinkedIn name
        fusion:   nil  # FL Fusion handle
      },  

      # This is an entirely NEW structure for the "layouts" area
      # You're able to define layouts, notifications etc ↴

      # All keys interpolated as strings, so you can use symbols, strings or integers where necessary
      exceptions: {

        :all => {
          layout: "exception", # define layout
          notification: true # (false by default)
          #deliver: #something here to control the type of response
        },
        '4xx' => {
          layout: nil, # define layout
          notification: true # (false by default)
          #deliver: #something here to control the type of response    
        },
        '5xx' => {
          layout: "exception", # define layout
          notification: true # (false by default)
          #deliver: #something here to control the type of response    
        },
        '500' => {
          layout: "exception", # define layout
          notification: true # (false by default)
          #deliver: #something here to control the type of response    
        }

        # This is the old structure
        # Still works but will be deprecated in future versions

        # 501 => "exception",
        # 502 => "exception",
        # 503 => "exception",
        # 504 => "exception",
        # 505 => "exception",
        # 507 => "exception",
        # 510 => "exception"

      }
    }

    config.i18n.default_locale = :ko
    config.i18n.available_locales = [:en, :ko]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.fallbacks = [:en]

    # Throttling
    Throttling.limits_config = "#{Rails.root}/config/throttling.yml"
    Throttling.enabled = true 
    
    # Sidekiq 
    #config.active_job.queue_adapter = :sidekiq

    config.action_controller.forgery_protection_origin_check = false

    config.hosts << "www.hanstyle.net"    
    
  end
end

# Elasticsearch 
#Elasticsearch::Model.client = Elasticsearch::Client.new host: '10.3.0.9:81', log: true

# Sidekiq.configure_server do |config|
  # config.redis = { url: ENV.fetch('SIDEKIQ_REDIS_URL', 'redis://127.0.0.1:6379/1') }
# end

# Sidekiq.configure_client do |config|
  # config.redis = { url: ENV.fetch('SIDEKIQ_REDIS_URL', 'redis://127.0.0.1:6379/1') }
# end

ActionMailer::Base.delivery_method = :sendmail

