require 'exogenesis/abstract_package_manager'

class Vundle < AbstractPackageManager
  def install
    create_vim_folder
    clone
    bundle_install
  end

  def teardown
    print "Removing Vundle..."
    target = File.join Dir.home, ".vim"

    if File.exists? target
      `rm -r #{target}`
      puts "Removed!"
    else
      puts "Did not exist"
    end
  end

  def update
    puts "Updating Vim Bundles"
    system "vim +BundleUpdate +qall"
  end

  private

  def create_vim_folder
    target = File.join Dir.home, ".vim"
    Dir.mkdir target unless File.exists? target
  end

  def clone
    target = File.join Dir.home, ".vim", "bundle", "vundle"

    if File.exists? target
      puts "Vundle already exists"
    else
      `git clone git://github.com/gmarik/vundle.git #{target}`
      puts "Cloned!"
    end
  end

  def bundle_install
    system "vim +BundleInstall\! +qall"
    system "vim +BundleClean\! +qall"
  end
end
