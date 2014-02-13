require 'exogenesis/support/passenger'

# Manages the Ruby Version Manager Rbenv
class Rbenv < Passenger
  register_as :rbenv
  needs :rubies

  def setup
    execute "Setup rbenv", "git clone https://github.com/sstephenson/rbenv.git ~/.rbenv"
    execute "Setup ruby-build plugin", "git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"
  end

  def teardown
    execute_interactive "Teardown", "rm -r ~/.rbenv"
  end

  def install
    rubies.each { |ruby| install_ruby ruby }
    execute "Rehash", "rbenv rehash"
  end

  def update
    execute "Update rbenv + ruby-build", "cd ~/.rbenv; git pull;cd ~/.rbenv/plugins/ruby-build; git pull"
    rubies.each { |ruby| install_ruby ruby }
    execute "Rehash", "rbenv rehash"
  end

private

  def install_ruby(ruby)
    if !installed_versions.include? ruby
      execute "Installing #{ruby}", "rbenv install #{ruby}"
    end
  end

  def installed_versions
    return @installed_versions if @installed_versions

    @installed_versions = []
    execute "Getting Installed Versions", "rbenv versions" do |output|
      output.scan(/^[\*]?\s*([\S]*).*$/).each do |ruby|
        @installed_versions << ruby[0]
      end
    end
    @installed_versions
  end
end
