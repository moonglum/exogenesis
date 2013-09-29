class Passenger
  # The arguments are arbitrary, please see the individual files for it
  def initialize
  end

  # Installs the package manager itself
  def setup
  end

  # Installs all packages (the list has to be provided in the initialize method)
  def install
  end

  # Updates the package manager itself and all packages
  def update
  end

  # Starts a clean-up process
  def cleanup
  end

  # Uninstalls all packages and the package manager itself
  def teardown
  end
end
