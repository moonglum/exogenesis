require 'exogenesis/support/passenger'

# Installs and Removes Fonts
class Fonts < Passenger
  def_delegator :@config, :fonts

  def install
    install_all_fonts
  end

  def update
    install_all_fonts
  end

  def teardown
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
    executor.execute "Copying #{File.basename file}", "cp #{file} #{File.join(ENV['HOME'], "Library/Fonts", File.basename(file))}"
  end

  def uninstall_font(file)
   executor.execute "Deleting #{File.basename file}", "rm #{File.join(ENV['HOME'], "Library/Fonts", File.basename(file))}"
  end
end