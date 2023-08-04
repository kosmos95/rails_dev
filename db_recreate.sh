#!/bin/sh 
bin/rails db:environment:set RAILS_ENV=development
bin/rails db:drop; 
bin/rails db:create; 
bin/rails db:migrate; 
bin/rails db:seed
