require 'exogenesis/support/passenger'

# Installs and removes OhMyZSH
class OhMyZSH < Passenger
  register_as :oh_my_zsh
  needs :username

  def up
    execute "Cloning", "git clone #{repo} #{target}" do |output, error_output|
      raise TaskSkipped.new("Already exists") if error_output.include? "already exists"
    end
  end

  def down
    execute "Removing", "rm -r #{target}" do |output, error_output|
      raise TaskSkipped.new("Folder not found") if error_output.include? "No such file or directory"
    end
  end

  private

  def target
    File.join Dir.home, ".oh-my-zsh"
  end

  def repo
    "git://github.com/#{username}/oh-my-zsh.git"
  end
end
