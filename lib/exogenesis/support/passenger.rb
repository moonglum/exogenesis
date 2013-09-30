require 'forwardable'
require 'exogenesis/support/executor'

class Passenger
  extend Forwardable

  def_delegators :@executor,
    :start_section,
    :start_task,
    :task_succeeded,
    :task_failed,
    :skip_task,
    :info,
    :create_path_in_home,
    :get_path_in_home,
    :execute,
    :execute_interactive

  def initialize(config, executor = Executor.instance)
    @config = config
    @executor = executor
  end
end
