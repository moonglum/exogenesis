# A wrapper around a passenger
class Spacesuit
  def initialize(passenger)
    @passenger = passenger
  end

  # Installs the package manager itself
  def setup
    if @passenger.respond_to? :setup
      start_section
      @passenger.setup
    end
  end

  # Installs all packages (the list has to be provided in the initialize method)
  def install
    if @passenger.respond_to? :install
      start_section
      @passenger.install
    end
  end

  # Updates the package manager itself and all packages
  def update
    if @passenger.respond_to? :update
      start_section
      @passenger.update
    end
  end

  # Starts a clean-up process
  def cleanup
    if @passenger.respond_to? :cleanup
      start_section
      @passenger.cleanup
    end
  end

  # Uninstalls all packages and the package manager itself
  def teardown
    if @passenger.respond_to? :teardown
      start_section
      @passenger.teardown
    end
  end

  private

  def start_section
    @passenger.executor.start_section @passenger.class.to_s
  end
end
