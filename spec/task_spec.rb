describe 'task' do
  let(:user) { 'deploy' }
  let(:escaped_user) { 'deploy' }

  before do
    Rake.application.rake_require 'capistrano/tasks/deploy'
    Rake.application.rake_require 'capistrano/tasks/git'
    Rake.application.rake_require 'capistrano/tasks/framework'
    Rake.application.rake_require 'capistrano/tasks/withrsync'

    server 'example1.com', user: user, roles: %w(web)
    server 'example2.com', user: user, roles: %w(app web)
    server 'example3.com', user: user, roles: %w(db), no_release: true

    set :application, 'my_app_name'
    set :repo_url, 'https://github.com/linyows/capistrano-withrsync.git'
    set :branch, 'master'
    set :deploy_to, Pathname.new('/var/www/app')
    set :scm, :git
    set :shared_path, deploy_to.join('shared')
    set :current_path, deploy_to.join('current')
    set :releases_path, deploy_to.join('releases')
    set :release_path, releases_path.join(Time.now.utc.strftime "%Y%m%d%H%M%S")
    set :rsync_with_submodules, submodule
    set :format_options, log_file: nil
    set :stage, 'test'
  end

  shared_context :create_src do
    before do
      allow_any_instance_of(SSHKit::Backend::Local).to receive(:execute).
        with(:git, :clone, nil, fetch(:repo_url), fetch(:rsync_src))
    end
  end

  shared_context :check_dir do
    before do
      allow_any_instance_of(SSHKit::Backend::Local).to receive(:execute).
        with("          if test ! -d tmp/deploy\n            then echo \"Directory does not exist '#{fetch :rsync_src}'\" 1>&2\n            false\n          fi\n", {:verbosity=>0})
    end
  end

  shared_context :stage do
    before do
      allow_any_instance_of(SSHKit::Backend::Local).to receive(:execute).
        with(:git, :fetch, nil, '--quiet --all --prune')
      allow_any_instance_of(SSHKit::Backend::Local).to receive(:execute).
        with(:git, :reset, '--hard origin/')
    end
  end

  shared_context :sync do
    before do
      1.upto 2 do |i|
        host = "example#{i}.com"
        allow_any_instance_of(SSHKit::Backend::Local).to receive(:execute).
          with(:rsync, '--recursive --delete --delete-excluded --exclude .git* --exclude .svn*',
            'tmp/deploy/', "#{escaped_user}@#{host}:#{fetch(:deploy_to)}/shared/deploy")
      end
    end
  end

  describe 'sync' do
    include_context :create_src
    include_context :check_dir
    include_context :stage
    include_context :sync

    it 'synchronizes to remote from local' do
      quietly { invoke :'rsync:sync' }
    end

    context 'includes space in username' do
      let(:user) { 'deploy user' }
      let(:escaped_user) { "deploy\ user" }

      it 'escapes username' do
        quietly { invoke :'rsync:sync' }
      end
    end
  end

  describe 'release' do
    include_context :create_src
    include_context :check_dir
    include_context :stage
    include_context :sync

    it 'releases from temp directory on remote' do
      allow_any_instance_of(SSHKit::Backend::Netssh).to receive(:execute).
        with(:rsync, '--archive --acls --xattrs',
          "#{fetch(:shared_path).join('deploy')}/", "#{fetch :release_path}/")

      quietly { invoke :'rsync:release' }
    end
  end
end
