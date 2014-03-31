require 'exogenesis/support/passenger'

# Manages the Ruby Version Manager Rbenv and the ruby installer ruby-build
class Rbenv < Passenger
  register_as :rbenv
  needs :rubies
  with_emoji :cyclone

  def up
    if command_exists? 'rbenv'
      update_rbenv
    else
      install_rbenv
    end
    rubies.each { |ruby| install_ruby ruby }
    execute 'Rehash', 'rbenv rehash'
  end

  def down
    execute_interactive 'Teardown', 'rm -r ~/.rbenv'
  end

  private

  def install_rbenv
    execute 'Install rbenv', 'git clone https://github.com/sstephenson/rbenv.git ~/.rbenv'
    execute 'Install ruby-build plugin', 'git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build'
  end

  def update_rbenv
    execute 'Update rbenv', 'cd ~/.rbenv && git pull'
    execute 'Update ruby-build', 'cd ~/.rbenv/plugins/ruby-build && git pull'
  end

  def install_ruby(ruby)
    return if installed_versions.include? ruby
    execute "Installing #{ruby}", "rbenv install #{ruby}"
  end

  def installed_versions
    return @installed_versions if @installed_versions

    @installed_versions = []
    execute 'Getting Installed Versions', 'rbenv versions' do |output|
      output.scan(/^[\*]?\s*([\S]*).*$/).each do |ruby|
        @installed_versions << ruby[0]
      end
    end
    @installed_versions
  end
end
