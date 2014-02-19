Capistrano with Rsync
=====================

Capistrano with rsync to deployment hosts from local repository.

[![Gem version](https://badge.fury.io/rb/capistrano-withrsync.png)][gem]

[capistrano]: https://github.com/capistrano/capistrano
[gem]: https://rubygems.org/gems/capistrano-withrsync

Requirements
------------

- Ruby >= 2.0
- Capistrano >= 3.1
- Rsync >= 2.6

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-withrsync'
```

And then execute:

```ruby
$ bundle
```

Or install it yourself as:

```ruby
$ gem install capistrano-withrsync
```

Usage
-----

Capfile:

```ruby
require 'capistrano/withrsync'
```

deploy as usual

```sh
$ cap deploy
```

Configuration
-------------

Set capistrano variables with `set name, value`.

Name          | Default | Description
------------- |-------- |------------
rsync_stage   | `tmp/deploy` | Path where to clone your repository for staging, checkouting and rsyncing. Can be both relative or absolute.
rsync_cache   | `shared/deploy` | Path where to cache your repository on the server to avoid rsyncing from scratch each time. Can be both relative or absolute.<br> Set to `nil` if you want to disable the cache.
rsync_options | `%w(--recursive --delete --delete-excluded --exclude .git* --exclude .svn*)` | Array of options to pass to `rsync`.  

Contributing
------------

1. Fork it ( http://github.com/<my-github-username>/capistrano-withrsync/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


Author
------

- [linyows][linyows]

[linyows]: https://github.com/linyows

License
-------

The MIT License (MIT)
