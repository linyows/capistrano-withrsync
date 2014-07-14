Rake::Task[:'deploy:check'].enhance [:'rsync:override_scm']
Rake::Task[:'deploy:updating'].enhance [:'rsync:override_scm']

namespace :rsync do
  set :rsync_options, %w(
    --recursive
    --delete
    --delete-excluded
    --exclude .git*
    --exclude .svn*
  )

  set :rsync_copy_options, %w(
    --archive
    --acls
    --xattrs
  )

  set :rsync_src, 'tmp/deploy'
  set :rsync_dest, 'shared/deploy'

  set :rsync_dest_fullpath, -> {
    path = fetch(:rsync_dest)
    path = "#{deploy_to}/#{path}" if path && path !~ /^\//
    path
  }

  desc 'Override scm tasks'
  task :override_scm do
    Rake::Task[:"#{scm}:check"].delete
    Rake::Task.define_task(:"#{scm}:check") do
      invoke :'rsync:check'
    end

    Rake::Task[:"#{scm}:create_release"].delete
    Rake::Task.define_task(:"#{scm}:create_release") do
      invoke :'rsync:release'
    end

    Rake::Task[:"#{scm}:set_current_revision"].delete
    Rake::Task.define_task(:"#{scm}:set_current_revision") do
      invoke :'rsync:set_current_revision'
    end
  end

  desc 'Check that the repository is reachable'
  task :check do
    fetch(:branch)
    run_locally do
      exit 1 unless strategy.check
    end

    invoke :'rsync:create_dest'
  end

  desc 'Create a destination for rsync on deployment hosts'
  task :create_dest do
    on release_roles :all do
      path = File.join fetch(:deploy_to), fetch(:rsync_dest)
      execute :mkdir, '-pv', path
    end
  end

  desc 'Create a source for rsync'
  task :create_src do
    next if File.directory? fetch(:rsync_src)

    run_locally do
      execute :git, :clone, fetch(:repo_url), fetch(:rsync_src)
    end
  end

  desc 'Stage the repository in a local directory'
  task stage: :'rsync:create_src' do
    run_locally do
      within fetch(:rsync_src) do
        execute :git, :fetch, '--quiet --all --prune'
        execute :git, :reset, "--hard origin/#{fetch(:branch)}"
      end
    end
  end

  desc 'Sync to deployment hosts from local'
  task sync: :'rsync:stage' do
    last_rsync_to = nil
    roles(:all).each do |role|
      run_locally do
        user = "#{role.user}@" if !role.user.nil?
        rsync_options = "#{fetch(:rsync_options).join(' ')}"
        rsync_from = "#{fetch(:rsync_src)}/"
        rsync_to = "#{user}#{role.hostname}:#{fetch(:rsync_dest_fullpath) || release_path}"

        unless rsync_to == last_rsync_to
          execute :rsync, rsync_options, rsync_from, rsync_to
          last_rsync_to = rsync_to
        end
      end
    end
  end

  desc 'Copy the code to the releases directory'
  task release: :'rsync:sync' do
    next if !fetch(:rsync_dest)

    on release_roles :all do
      execute :rsync,
        "#{fetch(:rsync_copy_options).join(' ')}",
        "#{fetch(:rsync_dest_fullpath)}/",
        "#{release_path}/"
    end
  end

  task :create_release do
    invoke :'rsync:release'
  end

  desc 'Set the current revision'
  task :set_current_revision do
    run_locally do
      within fetch(:rsync_src) do
        rev = capture(:git, 'rev-parse', '--short', 'HEAD')
        set :current_revision, rev
      end
    end
  end
end
