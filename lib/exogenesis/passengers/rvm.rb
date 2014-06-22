require 'exogenesis/support/passenger'

# Manages the Ruby Version Manager RVM
class Rvm < Passenger
  register_as :rvm
  needs :rubies
  with_emoji :cyclone

  def up
    if command_exists? 'rvm'
      skip_task 'Setup'
    else
      execute_interactive 'Setup', '\\curl -L https://get.rvm.io | bash -s'
    end
    execute 'Update', 'rvm get head'
    rubies.each { |ruby| install_or_update_ruby ruby }
    execute 'Reload', 'rvm reload'
  end

  def down
    execute_interactive 'Teardown', 'rvm implode'
  end

  private

  def install_or_update_ruby(ruby)
    if installed_versions[ruby].nil?
      install_ruby ruby
    else
      update_ruby installed_versions[ruby], ruby
    end
  end

  def install_ruby(ruby)
    execute "Installing #{ruby}", "rvm install #{ruby} --with-gcc=gcc-4.2"
  end

  def update_ruby(old_ruby, new_ruby)
    execute "Upgrading #{new_ruby}", "rvm upgrade #{old_ruby} #{new_ruby} --force --with-gcc=gcc-4.2" do |_output, error_output|
      raise TaskSkipped, 'Already Up to Date' if error_output.include? 'are the same'
    end
  end

  def installed_versions
    return @installed_versions if @installed_versions

    @installed_versions = {}
    execute 'Getting Installed Versions', 'rvm list' do |output|
      output.scan(/((\w+-[\w\.]+)(-(p\d+))?)/).each do |ruby|
        @installed_versions[ruby[1]] = ruby[0]
      end
    end
    @installed_versions
  end
end
