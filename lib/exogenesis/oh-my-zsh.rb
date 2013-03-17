require 'exogenesis/support/abstract_package_manager'
require 'exogenesis/support/executor'

# Installs and removes OhMyZSH
class OhMyZSH < AbstractPackageManager
  # If you want to use your own fork, just give your username
  # as an argument. The default is of course 'robbyrussell'.
  def initialize(username = "robbyrussell")
    @repo = "git://github.com/#{username}/oh-my-zsh.git"
    @executor = Executor.instance
  end

  def setup
    @executor.start_section "Oh-My-ZSH"

    if File.exists? target
      @executor.skip_task "Cloning", "Already Exists"
    else
      @executor.execute_interactive "Cloning", "git clone #{@repo} #{target}"
    end
  end

  def teardown
    @executor.start_section "Oh-My-ZSH"

    if File.exists? target
      @executor.execute_interactive "Removing", "rm -r #{target}"
    else
      @executor.skip_task "Removing", "Did not exist"
    end
  end

  private

  def target
    File.join Dir.home, ".oh-my-zsh"
  end
end
