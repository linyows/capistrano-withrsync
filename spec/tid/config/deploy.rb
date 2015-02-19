Rake::Task['metrics:collect'].clear_actions

set :application, 'capistrano_with_rsync'
set :repo_url, 'https://github.com/linyows/capistrano-withrsync.git'
set :deploy_to, '/var/capistrano_with_rsync'
set :scm, :git
set :format, :pretty
set :log_level, :debug
