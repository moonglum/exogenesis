require "singleton"
require "open3"
require "exogenesis/support/output"
require "exogenesis/support/task_skipped"

# Executor is a Singleton. Get the instance
# via `Executor.instance`
class Executor
  include Singleton

  def initialize
    @output = Output.instance
  end

  # Start a new output section with a given
  # text
  def start_section(text)
    @output.decorated_header(text)
  end

  # Notify the user that you started with a
  # task like 'Configure Homebrew'
  def start_task(text)
    @output.left(text)
  end

  # Notify the user that the started task
  # was successful.
  def task_succeeded(further_information = "")
    @output.success(further_information)
  end

  # Notify the user that the started task
  # failed.
  def task_failed(further_information, exit_status = 1)
    @output.failure(further_information)
    exit(exit_status)
  end

  # Notify the user that you have skipped a task
  def skip_task(description, further_information = "")
    @output.left(description)
    @output.skipped(further_information)
  end

  # Notify the user about something
  def info(description, information)
    @output.left(description)
    @output.info(information)
  end

  # Execute a shell script. The description will
  # be printed before the execution. This method
  # will handle failures of the executed script.
  # If you provide a block, execute will pass the output
  # of the execution to it. If you raise a TaskSkipped
  # Exception, it will skip the task instead of marking
  # it as done (and give the text you provided to the
  # exception as additional information if verbose is
  # active)
  def execute(description, script)
    start_task description

    output, error_output, exit_status = nil
    Open3.popen3(script) do |stdin, stdout, stderr, process|
      output = stdout.read
      error_output = stderr.read
      exit_status = process.value.exitstatus
    end

    yield(output, error_output) if block_given?

    if exit_status > 0
      task_failed("An Error occured while executing `#{script}`: \n#{output} #{error_output}", exit_status)
    else
      task_succeeded(output)
    end
  rescue TaskSkipped => e
    @output.skipped(e)
  end

  # Executes the script via system, so the user
  # can interact with the output. Instead of
  # the usual output of the other commands, it
  # will draw a border around the interactive section
  def execute_interactive(description, script)
    @output.start_border description
    system script
    @output.end_border
  end
end
