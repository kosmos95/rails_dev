source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

#ruby '2.7.2'
ruby '3.0.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '= 6.1.3'
#gem 'rails', '~> 6.0.0'

# Use mysql as the database for Active Record
#gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'mysql2', '>= 0.5.2', '< 0.6.0'

gem 'rack-mini-profiler'
# For memory profiling
gem 'memory_profiler'
# For call-stack profiling flamegraphs
gem 'flamegraph'
gem 'stackprof'

# Use Puma as the app server
gem 'puma' #, '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.12'

# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'
gem 'image_magick'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 10.0.2', platforms: [:mri, :mingw, :x64_mingw]
  #gem "ruby-debug-passenger"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'

  #gem 'adminlte-generators'
  #gem 'adminlte_assets', '~> 0.5.0'  
end

gem 'spring'

#gem 'yui-compressor'
  
group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootstrap', '~>4.1.1'

gem 'simple_form'

gem 'jquery-rails'

gem 'wdm', '>= 0.1.0' if Gem.win_platform?

gem 'high_voltage', '~> 3.1'

gem 'font-awesome-rails'
gem 'bootstrap_flash_messages', '~> 1.0.1'
#gem 'acts-as-taggable-on', '~> 6.0'

# Use Capistrano for deployment
group :development do 
  #gem 'capistrano', '~> 3.2.1'
  #gem 'capistrano-bundler' # for capistrano/bundler
  #gem 'capistrano-rails' # for capistrano/rails/*
  
  #gem 'capistrano-rbenv', '~> 2.0'
  #gem 'capistrano-rbenv-install', '~> 1.2.0'
  #gem 'capistrano-rails', group: :development
  #gem 'capistrano3-puma' , group: :development
  #gem 'capistrano-figaro-yml', '~> 1.0.2'
  #gem 'capistrano-upload-config'
  #gem 'capistrano3-nginx', '~> 2.0'
  #gem 'capistrano-rails-collection'
  #gem 'capistrano-ssh-doctor', '~> 1.0'
end 

# editor
# editor
#gem 'tinymce-rails', '~>4.0, <5.0'
gem 'tinymce-rails', '~> 4.0'
#gem 'tinymce-rails-imageupload', '~> 4.0.0.beta'
#gem 'tinymce-rails-imageupload', github: 'damulhan/tinymce-rails-imageupload'
gem 'tinymce-rails-imageupload', path: 'lib/vendor/tinymce-rails-imageupload'
gem 'tinymce-rails-langs'

#gem "wysiwyg-rails"
#gem "font-awesome-sass"

#gem 'smart_editor'

# exception handler 
gem 'exception_handler', '~> 0.8.0.0'

gem 'simple_navigation_renderers'

#gem 'devise'
gem 'devise', github: 'heartcombo/devise'
gem 'devise-encryptable'

gem 'cancancan', '~> 3.0'
gem 'rolify'

gem 'omniauth' #, '>= 1.6'
gem "omniauth-rails_csrf_protection"

gem 'omniauth-facebook'
gem "omniauth-google-oauth2", '~> 1.0.0'
gem 'omniauth-naver'
#gem 'omniauth-kakao', :github => 'hcn1519/omniauth-kakao'
#gem 'omniauth-kakao2', :path=>'lib/vendor/omniauth-kakao2'

# for configs 
gem 'figaro'
#gem "rails-settings-cached"
#gem 'dotenv-rails', groups: [:development, :test]
gem 'dotenv-rails'

#gem 'rails_admin', '~> 1.3'

#gem 'activeadmin', github: 'activeadmin/activeadmin'
#gem 'inherited_resources', github: 'activeadmin/inherited_resources'

gem 'rails-adminlte'

#gem 'will_paginate', '~> 3.1.0'
#gem 'will_paginate', github: 'damulhan/will_paginate'
#gem 'will_paginate'
gem 'will_paginate', :path=>'lib/vendor/will_paginate'

gem 'rails-i18n', '~> 6.0.0' # For 5.0.x, 5.1.x and 5.2.x

gem 'carrierwave', '~> 2.0'
gem 'carrierwave-i18n', github: 'damulhan/carrierwave-i18n'

gem "webpacker", '~>5.2.1'

gem 'throttling'

gem 'action_widget'

gem 'remotipart', '~> 1.2'

gem 'record_tag_helper', '~> 1.0'

gem 'rails_autolink', '~>1.1.6'

#gem 'draper', '~> 3' # only for Rails 5
gem 'draper'

#gem 'ruby-prof'

# redis 
#gem 'hiredis'
#gem "redis", "~> 4.1"

# memcached 
gem 'dalli', "~>2.7"

# Multi DB 
#gem 'ar-multidb', :require => 'multidb'

#gem 'remote_lock'

# idea: https://gist.github.com/torkale/2762063
# source: https://github.com/smira/memcache-lock
#gem 'memcache-lock', :path=>'lib/vendor/memcache-lock'

# elasticsearch 
gem 'elasticsearch-model', github: 'elastic/elasticsearch-rails', branch: '6.x'
gem 'elasticsearch-rails', github: 'elastic/elasticsearch-rails', branch: '6.x'

gem 'sidekiq'

gem 'sanitize'

# Ghostscript는 PDF 파일에 대한 썸네일 이미지를 생성하기 위해 사용된다.
#gem 'ghostscript'

gem "recaptcha", require: "recaptcha/rails"

#gem 'railswiki'

gem "i18n-js"

gem 'countries'

gem 'country_select', '~> 4.0'

################
# 추가 작업 
# yum install ImageMagick

# for sidekiq 
# production 
#gem 'faraday'

