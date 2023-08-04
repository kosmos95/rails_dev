#!/bin/sh
bundle exec pumactl --config-file config/puma.rb -S tmp/pids/server.state stop
