require 'exogenesis/support/passenger'

# Install NPM and NPM packages
# REQUIRES: Homebrew (so put it after your homebrew task)
class Npm < Passenger
  register_as :npm
  needs :npms

  def up
    if command_exists? 'npm'
      skip_task 'Install Node'
    else
      execute 'Install Node', 'brew install node'
    end

    installed = silent_execute('npm ls -g --depth=0').scan(/(\S+)@[\d.]+/).flatten

    npms.each do |package|
      if installed.include? package
        execute "Update #{package}", "npm update -g #{package}"
      else
        execute "Install #{package}", "npm install -g #{package}"
      end
    end
  end
end
