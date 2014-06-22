# A wrapper around a passenger
class Spacesuit
  def initialize(passenger)
    @passenger = passenger
  end

  # * Installs the package manager itself
  # * Installs all packages (the list has to be provided in the initialize method)
  # * Updates the package manager itself and all packages
  def up
    wrap :up
  end

  # Starts a clean-up process
  def clean
    wrap :clean
  end

  # Uninstalls all packages and the package manager itself
  def down
    wrap :down
  end

  private

  def wrap(task_name)
    return unless @passenger.respond_to? task_name
    @passenger.start_section @passenger.class.to_s
    @passenger.public_send task_name
  end
end
