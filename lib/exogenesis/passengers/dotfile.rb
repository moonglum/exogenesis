require 'exogenesis/support/passenger'

# Links all files in the given directory to your home directory
class Dotfile < Passenger
  register_as :dotfile
  needs :directory_name
  with_emoji :house

  def up
    each_dotfile do |source, destination|
      ln_s source, destination
    end
  end

  def down
    each_dotfile do |_source, destination|
      rm_rf destination
    end
  end

  private

  def each_dotfile
    get_path_in_working_directory(directory_name).each_child do |source|
      yield source, get_path_in_home(".#{source.basename}")
    end
  end
end
