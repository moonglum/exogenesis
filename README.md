# Exogenesis

| Project         | Exogenesis
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/moonglum/exogenesis
| CI              | [![Build Status](http://img.shields.io/travis/moonglum/exogenesis.svg)](http://travis-ci.org/moonglum/exogenesis)
| Code Metrics    | [![Code Climate](http://img.shields.io/codeclimate/github/moonglum/exogenesis.svg)](https://codeclimate.com/github/moonglum/exogenesis) [![Code Climate Coverage](http://img.shields.io/codeclimate/coverage/github/moonglum/exogenesis.svg)](https://codeclimate.com/github/moonglum/exogenesis)
| Gem Version     | [![Gem Version](http://img.shields.io/gem/v/exogenesis.svg)](http://rubygems.org/gems/exogenesis)
| Dependencies    | [![Dependency Status](http://img.shields.io/gemnasium/moonglum/exogenesis.svg)](https://gemnasium.com/moonglum/exogenesis)


A collection of classes that help you install, update and teardown package managers and other things useful for your dotfiles. It's something like a meta package manager (package manager is the wrong word... still searching for a better one). After setting it up you can do the following:

* `rake up`: Setup, install and update your software
* `rake down`: Remove everything installed by Exogenesis
* `rake clean`: Run cleanup tasks

It creates a beautiful output if you want it to (see Configuration). For a little [demonstration](http://ascii.io/a/2491) (a little updated) see this asciicast of my `rake install` running on my (already installed :wink:) system.

**Please read the source code of this gem before you use it. I give no guarantee that this will not destroy your computer entirely.**

## How to use it

The current best practice is to create a Rakefile in your dotfile repo that looks something like this:

```ruby
#!/usr/bin/env rake
require "yaml"
require "exogenesis"

Output.fancy
packages_file = YAML.load_file("packages.yml")
ship = Ship.new(packages_file)

[:up, :down, :clean].each do |task_name|
  desc "#{task_name.capitalize} the Dotfiles"
  task task_name do
    ship.public_send task_name
  end
end
```

You can find a list of real-world usage of this gem [here](https://github.com/moonglum/exogenesis/wiki/List-of-Users). There are links to the actual install files there, so you can see how they did it.

## If you use it...

...and you really like it, you can add the exogenesis badge to the title of your dotfile's README and link to this project:

![badge](http://img.shields.io/badge/%F0%9F%9A%80-Created_with_Exogenesis-be1d77.svg)

```markdown
[![badge](http://img.shields.io/badge/%F0%9F%9A%80-Created_with_Exogenesis-be1d77.svg)](https://github.com/moonglum/exogenesis)
```

## The Interface of the classes

Every class has the following methods (with the exception of `initialize` they all take no arguments):

* `initialize`: The arguments are arbitrary, please see the individual files for it
* `up`: Installs the package manager itself, all packages and updates the package manager itself and all packages
* `clean`: Starts a clean-up process
* `down`: Uninstalls all packages and the package manager itself

Not all package managers will need all of the methods. Just do not implement them.

## Supported Managers

* **Dotfile:** Link/Unlink your dotfiles
* **Fonts:** Manage your fonts
* **Homebrew:** Install/Uninstall/Update Homebrew and its packages
* **HomebrewCask:** Install/Tap [Homebrew Cask](http://caskroom.io) and its packages
* **RVM:** Install/Uninstall/Update RVM and Rubies
* **Rbenv:** Install/Uninstall/Update Rbenv+Ruby-Build and Rubies
* **Vundle:** Install/Uninstall/Update Vundle and its packages
* **GitRepo:** Clone/Pull Git Repos to certain paths
* **NPM**: Install/Uninstall NPM and its packages
* **Shell**: Executes commands on the shell

## Contributing

Additions of new classes are more than welcome, even if they are complimentary to the ones already provided. If you want to contribute a new class, please see the interface section and inherit from `Passenger`. Please use the Executor singleton for communicating the status with the user and for executing shell scripts.

So far, the following people have contributed to the project:

* Bodo Tasche aka @bitboxer
* Felix Schäfer aka @thegcat
* Gil Desmarais aka @gill0r
