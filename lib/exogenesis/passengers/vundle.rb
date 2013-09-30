require 'exogenesis/support/passenger'

# Manages the Vim Package Manager Vundle
class Vundle < Passenger
  VUNDLE_REPO = "git://github.com/gmarik/vundle.git"

  # The dependencies are read from your Vim files
  # It creates a `~/.vim` folder and clones Vundle.
  def setup
    create_path_in_home ".vim", "bundle", "vundle"
    execute "Cloning Vundle", "git clone #{VUNDLE_REPO} #{vundle_folder}" do |output, error_output|
      raise TaskSkipped.new("Already exists") if error_output.include? "already exists"
    end
  end

  # Runs BundleInstall in Vim
  def install
    execute_interactive "Install", "vim +BundleInstall\! +qall"
    execute_interactive "Clean", "vim +BundleClean\! +qall"
  end

  # Removes the ~/.vim folder
  def teardown
    execute "Removing Vim Folder", "rm -r #{vim_folder}" do |output|
      raise TaskSkipped.new("Folder not found") if output.include? "No such file or directory"
    end
  end

  # Updates all installed vundles
  def update
    execute_interactive "Updating Vim Bundles", "vim +BundleUpdate +qall"
  end

  # Runs BundleClean in Vim
  def cleanup
    execute_interactive "Cleaning", "vim +BundleClean\! +qall"
  end

  private

  def vim_folder
    get_path_in_home ".vim"
  end

  def vundle_folder
    create_path_in_home ".vim", "bundle", "vundle"
  end
end
