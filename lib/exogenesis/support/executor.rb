require 'fileutils'
require 'singleton'
require 'open3'
require 'bundler'
require 'exogenesis/support/output'
require 'exogenesis/support/task_skipped'

# Executor is a Singleton. Get the instance
# via `Executor.instance`
# If you add a public method here, please also
# add it to the `executor_double`. Same goes for
# removing public methods ;)
class Executor
  include Singleton

  def initialize
    @output = Output.instance
  end

  # Start a new output section with a given
  # text
  def start_section(text, emoji_name)
    @output.decorated_header(text, emoji_name)
  end

  # Notify the user that you started with a
  # task like 'Configure Homebrew'
  def start_task(text)
    @output.left(text)
  end

  # Notify the user that the started task
  # was successful.
  def task_succeeded(further_information = '')
    @output.success(further_information)
  end

  # Notify the user that the started task
  # failed.
  def task_failed(further_information, exit_status = 1)
    @output.failure(further_information)
    exit(exit_status)
  end

  # Notify the user that you have skipped a task
  def skip_task(description, further_information = '')
    @output.left(description)
    @output.skipped(further_information)
  end

  # Notify the user about something
  # TODO: It has to be possible to give an info for a started task
  def info(description, information)
    @output.left(description)
    @output.info(information)
  end

  # Create a path
  # Expects a PathName
  def mkpath(path)
    FileUtils.mkpath(path)
  end

  # Get a path starting from the home dir
  def get_path_in_home(*path)
    Pathname.new(File.join(Dir.home, *path))
  end

  # Get a path starting from the current working directory
  def get_path_in_working_directory(*path)
    Pathname.pwd.join(*path)
  end

  # Get an expanded PathName for a String
  def get_path_for(path_as_string)
    Pathname.new(File.expand_path(path_as_string))
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
    Bundler.with_clean_env do
      Open3.popen3(script) do |_stdin, stdout, stderr, process|
        output = stdout.read
        error_output = stderr.read
        exit_status = process.value.exitstatus
      end
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

  # Execute without printing anything, return the result
  # (Use instead of `command` to mock it)
  def silent_execute(command)
    Bundler.with_clean_env do
      `#{command}`
    end
  end

  # Wrapper around FileUtils' `rm_rf`
  # First check if the path exists, info if it doesn't exist
  # If it exists, ask if the user really wants to delete it
  # path: Needs to be a PathName
  def rm_rf(path)
    if path.exist?
      FileUtils.rm_rf(path) if ask?("Do you really want to `rm -rf #{path}?`")
    else
      info("Delete `#{path}`", 'Already deleted')
    end
  end

  # Wrapper around FileUtils' `ln_s`
  def ln_s(src, dest)
    if dest.symlink? && dest.readlink == src
      skip_task "Linking #{src}", 'Already linked'
    else
      start_task "Linking #{src}"
      if dest.exist? || dest.symlink?
        task_failed 'Target already exists'
      else
        FileUtils.ln_s(src, dest)
        task_succeeded
      end
    end
  end

  # Ask the user a yes/no question
  def ask?(question)
    start_task("#{question} (y for yes, everything else aborts)")
    STDIN.gets == "y\n"
  end

  # Clone a git repository
  # TODO: Currently only supports Github Repos, but should work in hub-style in the future
  # git_repo: A Github repo name
  # target: A path object where you want to clone to
  def clone_repo(git_repo, target)
    execute "Cloning #{git_repo}", "git clone git@github.com:#{git_repo}.git #{target}"
  end

  # Pull a git repository
  # git_repo: Is just used for the description
  # git_repo: A Github repo name (only used for task description)
  # target: A path object where you want to pull
  def pull_repo(git_repo, target)
    check_if_git_repo! target
    execute "Pulling #{git_repo}", "cd #{target} && git pull"
  end

  # Check if a command exists
  def command_exists?(command)
    system("which #{command} &>/dev/null;")
  end

  private

  # Path: A pathname object where you want to pull
  def check_if_git_repo!(path)
    start_task "Checking #{path.basename}"
    if path.children.one? { |child| child.basename.to_s == '.git' }
      task_succeeded
    else
      task_failed 'Not a git repository'
    end
  end
end
