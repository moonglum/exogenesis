require 'exogenesis/support/abstract_package_manager'
require 'exogenesis/support/executor'

# Links all files in the given directory to your home directory
class Dotfile < AbstractPackageManager
  # Give the directory name relative to the current directory
  # Defaults to "tilde", because you should call this directory
  # "tilde". (To be honest, I don't care how you call it.)
  def initialize(directory_name = "tilde")
    @directory_name = directory_name
    @executor = Executor.instance
  end

  def install
    @executor.start_section "Installing Dotfiles"
    file_names.each { |dotfile| link_file dotfile }
  end

  alias_method :update, :install

  def teardown
    @executor.start_section "Tearing town Dotfiles"
    file_names.each { |dotfile| unlink_file dotfile }
  end

  private

  def link_file(file_name)
    original = File.join Dir.pwd, @directory_name, file_name.to_s
    target = File.join Dir.home, ".#{file_name}"

    if File.symlink? target
      @executor.skip_task "Linking #{file_name}", "Already linked"
    else
      @executor.execute "Linking #{file_name}", "ln -s #{original} #{target}"
    end
  end

  def unlink_file(file_name)
    target = File.join Dir.home, ".#{file_name}"

    if File.symlink? target
      @executor.execute "Unlink #{target}", "rm #{target}"
    else
      @executor.skip_task "Unlink #{target}", "Link not found"
    end
  end

  def file_names
    file_names = Dir.entries(File.join(Dir.pwd, @directory_name))

    file_names.delete_if do |filename|
      filename.start_with? "."
    end
  end
end
