require 'exogenesis/support/passenger'

# Manages the Vim Package Manager Vundle
class Vundle < Passenger
  VUNDLE_REPO = 'git://github.com/gmarik/vundle.git'

  register_as :vundle
  with_emoji :gift

  def up
    if vundle_folder.exist?
      skip_task 'Cloning Vundle'
    else
      mkpath(vundle_folder)
      execute 'Cloning Vundle', "git clone #{VUNDLE_REPO} #{vundle_folder}"
    end
    execute_interactive 'Installing and Updating Vim Bundles', 'vim +BundleInstall\! +qall'
  end

  def down
    rm_rf vim_folder
  end

  def clean
    execute_interactive 'Cleaning', 'vim +BundleClean\! +qall'
  end

  private

  def vim_folder
    @vim_folder ||= get_path_in_home '.vim'
  end

  def vundle_folder
    @vundle_folder ||= get_path_in_home '.vim', 'bundle', 'vundle'
  end
end
