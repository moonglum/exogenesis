# A wrapper around a passenger
class Spacesuit
  def initialize(passenger)
    @passenger = passenger
  end

  # Installs the package manager itself
  def setup
    wrap :setup
  end

  # Installs all packages (the list has to be provided in the initialize method)
  def install
    wrap :install
  end

  # Updates the package manager itself and all packages
  def update
    wrap :update
  end

  # Starts a clean-up process
  def cleanup
    wrap :cleanup
  end

  # Uninstalls all packages and the package manager itself
  def teardown
    wrap :teardown
  end

  private

  def wrap(task_name)
    if @passenger.respond_to? task_name
      @passenger.start_section @passenger.class.to_s
      @passenger.public_send task_name
    end
  end
end
