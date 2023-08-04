#!/bin/sh

source /usr/local/rvm/environments/ruby-3.0.0

RAILS_SERVE_STATIC_FILES=true bundle exec pumactl -S tmp/pids/server.state start & 
