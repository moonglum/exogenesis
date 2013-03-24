require 'exogenesis/support/abstract_package_manager'
require 'exogenesis/support/executor'

# Manages the Vim Package Manager Vundle
class Vundle < AbstractPackageManager
  def initialize(executor = Executor.instance)
    @executor = executor
    @vundle_repo = "git://github.com/gmarik/vundle.git"
  end

  # The dependencies are read from your Vim files
  # It creates a `~/.vim` folder and clones Vundle.
  def setup
    @executor.start_section "Vundle"
    @executor.create_path_in_home ".vim", "bundle", "vundle"
    @executor.execute "Cloning Vundle", "git clone #{@vundle_repo} #{vundle_folder}" do |output, error_output|
      raise TaskSkipped.new("Already exists") if error_output.include? "already exists"
    end
  end

  # Runs BundleInstall in Vim
  def install
    @executor.start_section "Vundle"
    @executor.execute_interactive "Install", "vim +BundleInstall\! +qall"
    @executor.execute_interactive "Clean", "vim +BundleClean\! +qall"
  end

  # Removes the ~/.vim folder
  def teardown
    @executor.start_section "Vundle"
    @executor.execute "Removing Vim Folder", "rm -r #{vim_folder}" do |output|
      raise TaskSkipped.new("Folder not found") if output.include? "No such file or directory"
    end
  end

  # Updates all installed vundles
  def update
    @executor.start_section "Vundle"
    @executor.execute_interactive "Updating Vim Bundles", "vim +BundleUpdate +qall"
  end

  # Runs BundleClean in Vim
  def cleanup
    @executor.start_section "Vundle"
    @executor.execute_interactive "Cleaning", "vim +BundleClean\! +qall"
  end

  private

  def vim_folder
    @executor.get_path_in_home ".vim"
  end

  def vundle_folder
    @executor.create_path_in_home ".vim", "bundle", "vundle"
  end
end
