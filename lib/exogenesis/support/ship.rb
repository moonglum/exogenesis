require "ostruct"
require 'exogenesis/support/spacesuit'

class Ship
  def initialize(raw_config)
    config = OpenStruct.new(raw_config)
    @package_managers = []
    config.passengers.each do |passenger_name|
      passenger = Passenger.by_name(passenger_name).new(config)
      @package_managers << Spacesuit.new(passenger)
    end
  end

  def setup
    @package_managers.each(&:setup)
  end

  def install
    @package_managers.each(&:install)
  end

  def cleanup
    @package_managers.each(&:cleanup)
  end

  def update
    @package_managers.each(&:update)
  end

  def teardown
    @package_managers.each(&:teardown)
  end
end
