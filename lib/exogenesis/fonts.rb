require 'exogenesis/abstract_package_manager'

# Installs and Removes Fonts
class Fonts < AbstractPackageManager

  # This copies fonts from the dotfiles repo
  # to the directory where Mac OS expects the
  # Font. You can change the directory within
  # the repo if you want.
  def initialize(basepath = "fonts")
    @basepath = basepath
  end

  def install
    collect_fonts do |file|
      install_font(file)
    end
  end

  def teardown
    collect_fonts do |file|
      uninstall_font(File.basename(file))
    end
  end

  private

  def collect_fonts
    Dir.glob(File.join(@basepath, "**/*.ttf")).each do |file|
      yield file
    end
    Dir.glob(File.join(@basepath, "**/*.otf")).each do |file|
      yield file
    end
  end

  def install_font(file)
    puts "Installing #{File.basename file}"
    FileUtils.cp file, File.join(ENV['HOME'], "Library/Fonts", File.basename(file))
  end

  def uninstall_font(file)
   puts "Uninstalling #{file}"
   FileUtils.rm File.join(ENV['HOME'], "Library/Fonts", file)
  end
end
