require 'exogenesis/support/passenger'

# Install Python and pip packages
# REQUIRES: Homebrew (so put it after your homebrew task)
class Python < Passenger
  register_as :python
  needs :pips
  with_emoji :snake

  def up
    if command_exists? 'pip'
      skip_task 'Install Python'
    else
      execute 'Install Python', 'brew install python'
    end

    execute 'Link Python', 'brew link --overwrite python' do |output|
      raise TaskSkipped, 'Already linked' if output.include? 'Already linked'
    end

    (['pip'] + pips).each do |package|
      if installed_pips.include? package
        execute "Upgrade #{package}", "pip install --user --upgrade #{package}" do |output|
          raise TaskSkipped, 'Already up to date' if output.include? 'already up-to-date'
        end
      else
        execute "Install #{package}", "pip install --user #{package}"
      end
    end
  end

  private

  def installed_pips
    @installed_pips ||= silent_execute('pip list').scan(/(\S+) \([\d.]+\)/).flatten
  end
end
