require 'exogenesis/support/passenger'

class HomebrewCask < Passenger
  CASKROOM = 'caskroom/cask'

  register_as :homebrew_cask
  needs :casks

  def up
    tap_cask
    install_missing_casks
  end

  def clean
    execute 'Clean Up', 'brew cask cleanup'
  end

  def down
    uninstall_installed_casks
    untap_cask
  end

  private

  def install_missing_casks
    (casks || []).each do |cask|
      next if installed_casks.include?(cask)
      install_package cask
    end
  end

  def uninstall_installed_casks
    installed_casks.each do |cask|
      uninstall_package cask
    end
  end

  def install_package(name)
    execute "Installing #{name}", "brew cask install #{name}"
  end

  def uninstall_package(name)
    execute "Uninstalling #{name}", "brew cask uninstall #{name}"
  end

  def tap_cask
    if cask_tapped?
      skip_task 'Tap Cask'
    else
      execute_interactive 'Tap Cask', "brew tap #{CASKROOM}"
    end
  end

  def untap_cask
    execute 'Untap Cask', "brew untap #{CASKROOM}"
  end

  def cask_tapped?
    installed_taps.include?(CASKROOM)
  end

  def installed_casks
    @installed_casks ||= silent_execute('brew cask list').split(/\s/)
  end

  def installed_taps
    @installed_taps ||= silent_execute('brew tap').split(/\n/)
  end
end
