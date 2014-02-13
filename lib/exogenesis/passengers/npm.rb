require 'exogenesis/support/passenger'

# Install NPM and NPM packages
# REQUIRES: Homebrew (so put it after your homebrew task)
class Npm < Passenger
  register_as :npm
  needs :npms

  def setup
    execute "Install npm", "brew install npm" do |output|
      raise TaskSkipped.new("Already installed") if output.include? "already installed"
    end
  end

  def install
    npms.each do |package|
      execute "Install #{package}", "npm install -g #{package}"
    end
  end

  def up
    npms.each do |package|
      execute "Update #{package}", "npm update -g #{package}" 
    end
  end
end
