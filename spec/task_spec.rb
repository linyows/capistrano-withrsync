describe 'tasks' do
  before do
    Rake.application.rake_require 'capistrano/tasks/deploy'
    Rake.application.rake_require 'capistrano/tasks/git'
    Rake.application.rake_require 'capistrano/tasks/withrsync'

    server 'example1.com', roles: %w(web)
    server 'example2.com', roles: %w(app web)
    server 'example3.com', roles: %w(db), no_release: true

    set :repo_url, 'https://github.com/linyows/capistrano-withrsync.git'
    set :deploy_to, Pathname.new('/var/www/app')
    set :shared_path, deploy_to.join('shared')
    set :current_path, deploy_to.join('current')
    set :releases_path, deploy_to.join('releases')
    set :release_path, releases_path.join(Time.now.utc.strftime "%Y%m%d%H%M%S")
  end

  describe 'release' do
    it 'calls rsync commands and git commands' do
      allow_any_instance_of(SSHKit::Backend::Local).to receive(:execute).
        with(:git, :clone, nil, fetch(:repo_url), fetch(:rsync_src))
      allow_any_instance_of(SSHKit::Backend::Local).to receive(:execute).
        with("          if test ! -d tmp/deploy\n            then echo \"Directory does not exist '#{fetch :rsync_src}'\" 1>&2\n            false\n          fi\n", {:verbosity=>0})
      allow_any_instance_of(SSHKit::Backend::Local).to receive(:execute).
        with(:git, :fetch, nil, '--quiet --all --prune')
      allow_any_instance_of(SSHKit::Backend::Local).to receive(:execute).
        with(:git, :reset, '--hard origin/')

      1.upto 2 do |i|
        host = "example#{i}.com"
        allow_any_instance_of(SSHKit::Backend::Local).to receive(:execute).
          with(:rsync, '--recursive --delete --delete-excluded --exclude .git* --exclude .svn*',
            'tmp/deploy/', "#{host}:#{fetch(:deploy_to)}/shared/deploy")
      end

      allow_any_instance_of(SSHKit::Backend::Netssh).to receive(:execute).
        with(:rsync, '--archive --acls --xattrs',
          "#{fetch(:shared_path).join('deploy')}/", "#{fetch :release_path}/")

      quietly { invoke :'rsync:release' }
    end
  end
end
