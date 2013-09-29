require 'exogenesis/support/passenger'

# Manages the Ruby Version Manager RVM
class Rvm < Passenger
  def_delegator :@config, :rubies

  def setup
    executor.start_section "RVM"
    executor.execute_interactive "Setup", "\\curl -L https://get.rvm.io | bash -s"
  end

  def teardown
    executor.start_section "RVM"
    executor.execute_interactive "Teardown", "rvm implode"
  end

  def install
    executor.start_section "RVM"
    rubies.each { |ruby| install_ruby ruby }
  end

  def update
    executor.start_section "RVM"
    executor.execute_interactive "Update", "rvm get head"
    executor.execute "Reload", "rvm reload"
    current = installed_versions
    rubies.each { |ruby| install_or_update_ruby current, ruby }
  end

private

  def install_or_update_ruby(current, ruby)
    if current[ruby].nil?
      install_ruby ruby
    else
      update_ruby current[ruby], ruby
    end
  end

  def install_ruby(ruby)
    executor.execute "Installing #{ruby}", "rvm install #{ruby} --with-gcc=gcc-4.2" do |output|
      raise TaskSkipped.new("Already installed") if output.include? "Already Installed"
    end
  end

  def update_ruby(old_ruby, new_ruby)
    executor.execute "Upgrading #{new_ruby}", "rvm upgrade #{old_ruby} #{new_ruby} --force --with-gcc=gcc-4.2" do |output, error_output|
      raise TaskSkipped.new("Already Up to Date") if error_output.include? "are the same"
    end
  end

  def installed_versions
    result = {}
    executor.execute "Getting Installed Versions", "rvm list" do |output|
      output.scan(/((\w+-[\w\.]+)(-(p\d+))?)/).each do |ruby|
        result[ruby[1]] = ruby[0]
      end
    end
    result
  end
end
