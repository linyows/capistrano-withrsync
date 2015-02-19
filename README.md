Capistrano with Rsync
=====================

Capistrano with rsync to deployment hosts from local repository.

[![Gem version](https://img.shields.io/gem/v/capistrano-withrsync.svg?style=flat-square)][gem]
[![Wercker](https://img.shields.io/wercker/ci/54e13fa93e143292231f6e0a.svg?style=flat-square)][wercker]

[capistrano]: https://github.com/capistrano/capistrano
[gem]: https://rubygems.org/gems/capistrano-withrsync
[wercker]: https://app.wercker.com/project/bykey/195d63561202a1415822a18e0fd35994

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

```sh
$ bundle
```

Or install it yourself as:

```sh
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

Options
-------

Set capistrano variables with `set name, value`.

Name          | Default                                                                    | Description
    ------------- | --------                                                                   | ------------
rsync_src     | tmp/deploy                                                                 | rsync src path
rsync_dest    | shared/deploy                                                              | rsync dest path
rsync_options | --recursive --delete --delete-excluded <br>--exclude .git* --exclude .svn* | rsync options
rsync_with_submodules | false                                                              | fetch and update git submodules for syncing

Overview
--------

### local machine

```log
~/your_project
.
|-- app
|-- config
|-- lib
|-- ...
|-- ...
`-- tmp
    `-- deploy (rsync src ==>)
```

### deployment hosts

```log
/var/www/your_project
.
|-- current -> /var/www/your_project/releases/20140219074628
|-- releases
|   |-- 20140219062041
|   |-- 20140219063022
|   `-- 20140219074628
|-- revisions.log
`-- shared
    |-- vendor
    |-- deploy (==> rsync dest)
    `-- log
```

Contributing
------------

1. Fork it ( http://github.com/linyows/capistrano-withrsync/fork )
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
