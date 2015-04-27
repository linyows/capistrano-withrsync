require 'capistrano/withrsync/version'
require 'capistrano/withrsync/rake/task'
require 'shellwords'
load File.expand_path('../tasks/withrsync.rake', __FILE__)

module Capistrano
  module Withrsync
  end
end
