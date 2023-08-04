#!/bin/sh
RAILS_SERVE_STATIC_FILES=true bundle exec rails s -b 127.0.0.1 -p 9000 -e test -d 

