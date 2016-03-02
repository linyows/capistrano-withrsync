require 'capistrano/all'
require 'rspec'

load 'capistrano/setup.rb'

def run_task(name, *args)
  Rake.application.options.trace = !!ENV['DEBUG']
  Rake::Task[name].reenable
  Rake::Task[name].invoke(*args)
end
