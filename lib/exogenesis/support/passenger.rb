require 'forwardable'
require 'exogenesis/support/executor'

class Passenger
  extend Forwardable

  class << self
    attr_accessor :passengers

    def by_name(name)
      passengers[name]
    end

    def register_as(name)
      Passenger.passengers = {} if Passenger.passengers.nil?
      Passenger.passengers[name.to_s] = self
    end

    def needs(config_name)
      def_delegator :@config, config_name
    end
  end

  def_delegators :@executor,
    :start_section,
    :start_task,
    :task_succeeded,
    :task_failed,
    :skip_task,
    :info,
    :mkpath,
    :get_path_in_home,
    :get_path_in_working_directory,
    :get_path_for,
    :execute,
    :execute_interactive,
    :silent_execute,
    :ln_s,
    :rm_rf,
    :ask?,
    :clone_repo,
    :pull_repo,
    :command_exists?

  def initialize(config, executor = Executor.instance)
    @config = config
    @executor = executor
  end
end
