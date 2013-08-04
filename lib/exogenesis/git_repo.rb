require 'exogenesis/support/abstract_package_manager'
require 'exogenesis/support/executor'

# Clone, Update and Delete Git Repos
# REQUIRES: git
class GitRepo < AbstractPackageManager
  # Initialize with a hash mapping GitHub Repos to
  # pathes you want to clone to.
  def initialize(repos, executor = Executor.instance)
    @executor = executor
    @repos = repos
  end

  # `git clone` all those repos to the given target
  def install
    @executor.start_section "GitRepo"
    @repos.each_pair do |git_repo, target|
      @executor.execute "Cloning #{git_repo}", "git clone git@github.com:#{git_repo}.git #{target}" do |_, output|
        raise TaskSkipped.new("Already cloned") if output.include? "already exists"
      end
    end
  end

  # `git pull` all those repos
  def update
    @executor.start_section "GitRepo"
    @repos.each_pair do |git_repo, target|
      @executor.execute "Pulling #{git_repo}", "cd #{target} && git pull"
    end
  end
end
