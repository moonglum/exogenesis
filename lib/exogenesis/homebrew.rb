require 'exogenesis/abstract_package_manager'

# Manages Homebrew - the premier package manager for Mac OS
class Homebrew < AbstractPackageManager
  # Expects an array of packages to install, a package can either be:
  # * A String: Then it will just install the package with this name
  # * An Object with a single key value pair. The key is the name of the package, the value is an array of options passed to it
  def initialize(brews)
    @brews = brews
  end

  def update
    puts "Updating Homebrew..."
    `brew update`
    puts "Upgrading the following apps: #{`brew outdated`}"
    `brew upgrade`
  end

  def install
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

  def install_package(name, options = [])
    print "Installing #{name}... "
    status = `brew install #{name} #{options.join}`

    raise "No formula for #{name}" if status.include? "No available formula"

    if status.include? "already installed"
      puts "Already Installed!"
    else
      puts "Installed!"
    end
  end
end
