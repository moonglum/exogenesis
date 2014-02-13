require 'exogenesis/support/passenger'

# Manages Homebrew - the premier package manager for Mac OS
class Homebrew < Passenger
  INSTALL_SCRIPT = "https://raw.github.com/mxcl/homebrew/go"
  TEARDOWN_SCRIPT = "https://gist.github.com/mxcl/1173223/raw/a833ba44e7be8428d877e58640720ff43c59dbad/uninstall_homebrew.sh"

  register_as :homebrew
  needs :brews

  def setup
    # Feels wrong to call out to the terminal to start up a new Ruby oO
    execute_interactive "Install", "ruby -e \"$(curl -fsSL #{INSTALL_SCRIPT})\""
  end

  def cleanup
    execute "Clean Up", "brew cleanup"
  end

  def teardown
    execute "Teardown", "\\curl -L #{TEARDOWN_SCRIPT} | bash -s"
  end

  def update
    execute "Updating Homebrew", "brew update"
    outdated_packages = outdated
    if outdated_packages.length == 0
      info "Brews", "All up to date"
    else
      execute "Upgrade #{outdated_packages.join(", ")}", "brew upgrade #{outdated_packages.join(" ")}"
    end
  end

  def install
    brews.each do |brew|
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
    execute "Installing #{name}", "brew install #{name} #{options.join}" do |output|
      raise TaskSkipped.new("Already installed") if output.include? "already installed"
    end
  end
end
