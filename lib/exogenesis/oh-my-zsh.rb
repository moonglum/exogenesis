require 'exogenesis/abstract_package_manager'

# Installs and removes OhMyZSH
class OhMyZSH < AbstractPackageManager
  # If you want to use your own fork, just give your username
  # as an argument. The default is of course 'robbyrussell'.
  def initialize(username = "robbyrussell")
    @repo = "git://github.com/#{username}/oh-my-zsh.git"
  end

  def install
    print "Cloning Oh-my-zsh..."
    target = File.join Dir.home, ".oh-my-zsh"

    if File.exists? target
      puts "Oh-my-zsh already exists"
    else
      `git clone #{@repo} #{target}`
      puts "Cloned!"
    end
  end

  def teardown
    print "Removing Oh-my-zsh..."
    target = File.join Dir.home, ".oh-my-zsh"

    if File.exists? target
      `rm -r #{target}`
      puts "Removed!"
    else
      puts "Did not exist"
    end
  end
end
