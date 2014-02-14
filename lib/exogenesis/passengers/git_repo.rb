require 'exogenesis/support/passenger'

# Clone, Update and Delete Git Repos
# REQUIRES: git
class GitRepo < Passenger
  register_as :git_repo
  needs :repos

  # Clone the Repo if it doesn't exist
  # Pull the Repo if it does
  def up
    repos.each_pair do |git_repo, raw_target|
      target = get_path_for(raw_target)
      if target.exist?
        pull_repo(git_repo, target)
      else
        clone_repo(git_repo, target)
      end
    end
  end

  # Delete the Repos
  def down
    repos.each_pair do |_, target|
      rm_rf(get_path_for(target))
    end
  end
end
