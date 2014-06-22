require 'exogenesis/support/passenger'

# Manages Homebrew - the premier package manager for Mac OS
class Homebrew < Passenger
  INSTALL_SCRIPT = 'https://raw.github.com/mxcl/homebrew/go'
  TEARDOWN_SCRIPT = 'https://gist.github.com/mxcl/1173223/raw/a833ba44e7be8428d877e58640720ff43c59dbad/uninstall_homebrew.sh'

  register_as :homebrew
  needs :brews
  with_emoji :beer

  def up
    install_homebrew
    install_missing_brews
    update_existing_brews
  end

  def clean
    execute 'Clean Up', 'brew cleanup'
  end

  def down
    execute 'Teardown', "\\curl -L #{TEARDOWN_SCRIPT} | bash -s"
  end

  private

  def install_homebrew
    if command_exists? 'brew'
      skip_task 'Install Homebrew'
    else
      execute_interactive 'Install Homebrew', "ruby -e \"$(curl -fsSL #{INSTALL_SCRIPT})\""
    end
  end

  def install_missing_brews
    each_brew_to_install do |brew, options|
      install_package brew, options
    end
  end

  def update_existing_brews
    execute 'Updating Homebrew', 'brew update'

    if outdated_brews.length == 0
      skip_task 'Upgrade Brews'
    else
      info 'Outdated Brews', outdated_brews.join(', ')
      execute 'Upgrade Brews', 'brew upgrade'
    end
  end

  def each_brew_to_install
    brews.each do |brew|
      if brew.class == String
        name = brew
        options = []
      else
        name = brew.keys.first
        options = brew[name]
      end

      yield name, options unless installed_brews.include? name
    end
  end

  def installed_brews
    @installed_brews ||= silent_execute('brew ls').split(/\s/)
  end

  def outdated_brews
    @outdated_brews ||= silent_execute('brew outdated').split(/\s/)
  end

  def install_package(name, options)
    execute "Installing #{name}", "brew install #{name} #{options.join}"
  end
end
