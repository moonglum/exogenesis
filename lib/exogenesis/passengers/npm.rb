require 'exogenesis/support/passenger'

# Install NPM and NPM packages
# REQUIRES: Homebrew (so put it after your homebrew task)
class Npm < Passenger
  register_as :npm
  needs :npms
  with_emoji :cyclone

  def up
    install_node

    npms.each do |package|
      if installed.include? package
        update_package(package)
      else
        install_package(package)
      end
    end
  end

  private

  def install_node
    if command_exists? 'npm'
      skip_task 'Install Node'
    else
      execute 'Install Node', 'brew install node'
    end
  end

  def installed
    @installed ||= silent_execute('npm ls -g --depth=0').scan(/(\S+)@[\d.]+/).flatten
  end

  def update_package(package)
    execute "Update #{package}", "npm update -g #{package}"
  end

  def install_package(package)
    execute "Install #{package}", "npm install -g #{package}"
  end
end
