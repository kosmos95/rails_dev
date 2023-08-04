#!/bin/sh
#cd /var/www/rails/hcafe2; 
#--logfile log/sidekiq.log -d

source /usr/local/rvm/environments/ruby-3.0.0

nohup bin/bundle exec sidekiq --verbose --environment production --config config/sidekiq.yml >> log/sidekiq.log  & 

