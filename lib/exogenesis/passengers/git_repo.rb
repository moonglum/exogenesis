require 'exogenesis/support/passenger'

# Clone, Update and Delete Git Repos
# REQUIRES: git
class GitRepo < Passenger
  def_delegator :@config, :repos

  register_as :git_repo

  # `git clone` all those repos to the given target
  def install
    repos.each_pair do |git_repo, target|
      execute "Cloning #{git_repo}", "git clone git@github.com:#{git_repo}.git #{target}" do |_, output|
        raise TaskSkipped.new("Already cloned") if output.include? "already exists"
      end
    end
  end

  # `git pull` all those repos
  def update
    repos.each_pair do |git_repo, target|
      execute "Pulling #{git_repo}", "cd #{target} && git pull"
    end
  end
end
