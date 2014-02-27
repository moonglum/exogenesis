require "rspec/mocks"

# This is a stub you can use in your tests that has the
# same interface as the original executor
module ExecutorDouble
  def executor_double
    executor = double
    executor.stub(:start_section)
    executor.stub(:start_task)
    executor.stub(:task_succeeded)
    executor.stub(:task_failed)
    executor.stub(:skip_task)
    executor.stub(:info)
    executor.stub(:mkdir)
    executor.stub(:get_path_in_home)
    executor.stub(:get_path_in_working_directory)
    executor.stub(:get_path_for)
    executor.stub(:execute)
    executor.stub(:execute_interactive)
    executor.stub(:silent_execute)
    executor.stub(:rm_rf)
    executor.stub(:ln_s)
    executor.stub(:ask?)
    executor.stub(:clone_repo)
    executor.stub(:pull_repo)
    executor.stub(:command_exists?)
    executor
  end
end
