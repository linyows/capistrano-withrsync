load 'capistrano/setup.rb'

describe :rsync do
  before do
    Rake.application.rake_require 'capistrano/tasks/deploy'
    Rake.application.rake_require 'capistrano/tasks/git'
    Rake.application.rake_require 'capistrano/tasks/withrsync'
  end

  describe :release do
    it '' do
      repo = 'https://github.com/linyows/capistrano-withrsync.git'
      set :repo_url, repo

      execute = allow_any_instance_of(SSHKit::Backend::Local).to receive(:execute)
      execute.with(:git, :clone, nil, repo, 'tmp/deploy')
      execute.with("          if test ! -d tmp/deploy\n            then echo \"Directory does not exist 'tmp/deploy'\" 1>&2\n            false\n          fi\n", {:verbosity=>0})
      execute.with(:git, :fetch, nil, '--quiet --all --prune')
      execute.with(:git, :reset, '--hard origin/')

      invoke :'rsync:release'
    end
  end
end
