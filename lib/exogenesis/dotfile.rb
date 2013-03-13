require 'exogenesis/abstract_package_manager'

# Links all files in the directory `tilde` to your home directory
class Dotfile < AbstractPackageManager
  def install
    file_names.each { |dotfile| link_file dotfile }
  end

  def teardown
    file_names.each { |dotfile| unlink_file dotfile }
  end

  private

  def link_file(file_name)
    original = File.join Dir.pwd, "tilde", file_name.to_s
    target = File.join Dir.home, ".#{file_name}"

    if File.symlink? target
      puts "#{file_name} already linked"
    else
      puts "Linking #{file_name}"
      `ln -s #{original} #{target}`
    end
  end

  def unlink_file(file_name)
    target = File.join Dir.home, ".#{file_name}"

    if File.symlink? target
      `rm #{target}`
      puts "Symlink for #{target} removed"
    else
      puts "No symlink for #{target} existed."
    end
  end

  def file_names
    file_names = Dir.entries(File.join(Dir.pwd, "tilde"))

    file_names.delete_if do |filename|
      filename[0] == "."
    end
  end
end
