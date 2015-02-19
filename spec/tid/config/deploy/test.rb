host = ENV['TID_HOSTNAME']
port = ENV['TID_PORT']

server host,
  user: 'root',
  roles: %w(app),
  ssh_options: {
    port: port,
    user: 'root',
    keys: %w(./id_rsa),
    forward_agent: false,
    auth_methods: %w(publickey)
  }

namespace :rsync do
  set :rsync_options, [
    "-e 'ssh -p #{port} -i ./id_rsa'",
    '--recursive',
    '--delete',
    '--delete-excluded',
    '--exclude .git*',
    '--exclude .svn*',
  ]
end
