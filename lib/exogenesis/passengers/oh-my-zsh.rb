require 'exogenesis/support/passenger'
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
    @executor.execute "Cloning", "git clone #{@repo} #{target}" do |output, error_output|
      raise TaskSkipped.new("Already exists") if error_output.include? "already exists"
    end
  end

  def teardown
    @executor.start_section "Oh-My-ZSH"
    @executor.execute "Removing", "rm -r #{target}" do |output, error_output|
      raise TaskSkipped.new("Folder not found") if error_output.include? "No such file or directory"
    end
  end

  private

  def target
    File.join Dir.home, ".oh-my-zsh"
  end
end
