require 'capistrano/all'
require 'rspec'

def run_task(name = nil, *args)
  name = if name
           "#{self.class.top_level_description}:#{name}"
         else
           "#{self.class.top_level_description}"
         end

  Rake::Task.define_task(:environment)
  Rake::Task[name].reenable
  Rake::Task[name].invoke(*args)
end
