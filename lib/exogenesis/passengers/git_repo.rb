require 'exogenesis/support/passenger'

# Clone, Update and Delete Git Repos
# REQUIRES: git
class GitRepo < Passenger
  register_as :git_repo
  needs :repos

  # Clone the Repo if it doesn't exist
  # Pull the Repo if it does
  def up
    each_repo_and_target do |git_repo, target|
      if target.exist?
        pull_repo(git_repo, target)
      else
        clone_repo(git_repo, target)
      end
    end
  end

  # Delete the Repos
  def down
    each_repo_and_target do |_, target|
      rm_rf(target)
    end
  end

  private

  def each_repo_and_target
    repos.each_pair do |git_repo, raw_target|
      yield git_repo, get_path_for(raw_target)
    end
  end
end
