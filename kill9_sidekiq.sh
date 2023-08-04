ps aux | grep sidekiq | grep -v grep | kill -9 `awk '{print $2}'`
