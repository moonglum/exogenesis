require 'exogenesis/support/abstract_package_manager'

# Installs and Removes Fonts
class Fonts < AbstractPackageManager

  # This copies fonts from the dotfiles repo
  # to the directory where Mac OS expects the
  # Font. You can change the directory within
  # the repo if you want.
  def initialize(basepath = "fonts")
    @basepath = basepath
    @executor = Executor.instance
  end

  def install
    @executor.start_section "Installing Fonts"
    install_all_fonts
  end

  def update
    @executor.start_section "Updateing Fonts"
    install_all_fonts
  end

  def teardown
    @executor.start_section "Tearing town Fonts"
    collect_fonts do |file|
      uninstall_font(File.basename(file))
    end
  end

  private

  def install_all_fonts
    collect_fonts do |file|
      install_font(file)
    end
  end

  def collect_fonts
    Dir.glob(File.join(@basepath, "**/*.ttf")).each do |file|
      yield file
    end
    Dir.glob(File.join(@basepath, "**/*.otf")).each do |file|
      yield file
    end
  end

  def install_font(file)
    @executor.execute "Copying #{File.basename file}", "cp #{file} #{File.join(ENV['HOME'], "Library/Fonts", File.basename(file))}"
  end

  def uninstall_font(file)
   @executor.execute "Deleting #{File.basename file}", "rm #{File.join(ENV['HOME'], "Library/Fonts", File.basename(file))}"
  end
end
