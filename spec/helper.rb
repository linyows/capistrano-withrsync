require 'capistrano/all'
require 'rspec'

load 'capistrano/setup.rb'

def quietly
  silence_stream(STDOUT) do
    silence_stream(STDERR) do
      yield
    end
  end
end

def silence_stream(stream)
  old_stream = stream.dup
  stream.reopen(RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? 'NUL:' : '/dev/null')
  stream.sync = true
  yield
ensure
  stream.reopen(old_stream)
  old_stream.close
end
