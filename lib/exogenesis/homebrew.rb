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
    @install_script = "https://raw.github.com/mxcl/homebrew/go"
    @teardown_script = "https://gist.github.com/mxcl/1173223/raw/a833ba44e7be8428d877e58640720ff43c59dbad/uninstall_homebrew.sh"
  end

  def setup
    @executor.start_section "Homebrew"
    # Feels wrong to call out to the terminal to start up a new Ruby oO
    @executor.execute_interactive "Install", "ruby -e \"$(curl -fsSL #{@install_script})\""
  end

  def cleanup
    @executor.start_section "Homebrew"
    @executor.execute "Clean Up", "brew cleanup"
  end

  def teardown
    @executor.start_section "Homebrew"
    @executor.execute "Teardown", "\\curl -L #{@teardown_script} | bash -s"
  end

  def update
    @executor.start_section "Homebrew"
    @executor.execute "Updating Homebrew", "brew update"
    outdated_packages = outdated
    if outdated_packages == 0
      @executor.info "Brews", "All up to date"
    else
      outdated_packages.each do |package|
        @executor.execute "Upgrade #{package}", "brew upgrade #{package}"
      end
    end
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
    `brew outdated`.split("\n")
  end

  def install_package(name, options = [])
    @executor.execute "Installing #{name}", "brew install #{name} #{options.join}" do |output|
      raise TaskSkipped.new("Already installed") if output.include? "already installed"
    end
  end
end
