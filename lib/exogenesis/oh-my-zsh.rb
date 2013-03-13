require 'exogenesis/abstract_package_manager'

class OhMyZSH < AbstractPackageManager
  def install
    print "Cloning Oh-my-zsh..."
    target = File.join Dir.home, ".oh-my-zsh"

    if File.exists? target
      puts "Oh-my-zsh already exists"
    else
      `git clone git://github.com/moonglum/oh-my-zsh.git #{target}`
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
