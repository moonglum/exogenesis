require 'forwardable'
require 'exogenesis/support/executor'

class Passenger
  extend Forwardable

  attr_reader :executor

  def initialize(config, executor = Executor.instance)
    @config = config
    @executor = executor
  end
end
