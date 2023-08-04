ps aux | grep memcached | grep -v grep | kill -9 `awk '{print $2}'`
