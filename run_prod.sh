#!/bin/sh
#RAILS_SERVE_STATIC_FILES=true bin/bundle exec rails s -b 127.0.0.1 -p 9000 -e production -d
#RAILS=/usr/local/rvm/rubies/ruby-2.6.5/bin/ruby
#RAILS_SERVE_STATIC_FILES=true rvmsudo $RAILS s -b 127.0.0.1 -p 9000 -e production -d
#RAILS_SERVE_STATIC_FILES=true bin/bundle exec rails s -b 127.0.0.1 -p 9000 -e production -d
#export RAILS_SERVE_STATIC_FILES=true 

source /usr/local/rvm/environments/ruby-3.0.0

export RAILS_SERVE_STATIC_FILES=false
#/usr/local/rvm/bin/rvm use 2.7.0 do bundle exec 
service memcached restart
bin/rails s -b 127.0.0.1 -p 9010 -e production -d

