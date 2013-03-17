require 'exogenesis/support/abstract_package_manager'
require 'exogenesis/support/executor'

# Manages Homebrew - the premier package manager for Mac OS
class Homebrew < AbstractPackageManager
  # Expects an array of packages to install, a package can either be:
  # * A String: Then it will just install the package with this name
  # * An Object with a single key value pair. The key is the name of the package, the value is an array of options passed to it
  def initialize(brews)
    @brews = brews
    @executor = Executor.instance
  end

  def update
    @executor.start_section "Homebrew"
    @executor.execute "Updating Homebrew", "brew update"
    @executor.info "Outdated brews", outdated
    @executor.execute "Upgrading brews", "brew upgrade"
  end

  def install
    @executor.start_section "Homebrew"
    @brews.each do |brew|
      if brew.class == String
        install_package brew
      else
        name = brew.keys.first
        options = brew[name]
        install_package name, options
      end
    end
  end

  private

  def outdated
    `brew outdated`.split("\n").join(", ")
  end

  def install_package(name, options = [])
    @executor.execute "Installing #{name}", "brew install #{name} #{options.join}" do |output|
      raise TaskSkipped.new("Already installed") if output.include? "already installed"
    end
  end
end
