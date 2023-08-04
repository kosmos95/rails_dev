# encoding: utf-8
require 'rbconfig'
#require File.expand_path('../lib/will_paginate/version', __FILE__)
#require File.expand_path('.', 'VERSION')

Gem::Specification.new do |s|
  s.name    = 'memcache-lock'
  s.version = "0.2.0" 
  
  s.summary = "memcache-lock"
  #s.description = "will_paginate provides a simple API for performing paginated queries with Active Record, DataMapper and Sequel, and includes helpers for rendering pagination links in Rails, Sinatra and Merb web apps."
  
  s.authors  = ['smira']
  s.email    = 'smira@gmail.com'
  s.homepage = 'https://github.com/smira/memcache-lock'
  s.license  = 'MIT'
  
  s.rdoc_options = ['--main', 'README.md', '--charset=UTF-8']
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE']
  
  s.files = Dir['Rakefile', '{lib,spec}/**/*', 'README*', 'LICENSE*']

  # include only files in version control
  git_dir = File.expand_path('../.git', __FILE__)
  void = defined?(File::NULL) ? File::NULL :
    RbConfig::CONFIG['host_os'] =~ /msdos|mswin|djgpp|mingw/ ? 'NUL' : '/dev/null'

  if File.directory?(git_dir) and system "git --version >>#{void} 2>&1"
    s.files &= `git --git-dir='#{git_dir}' ls-files -z`.split("\0") 
  end
end
