require "spec_helper"
require "exogenesis/passengers/git_repo"

describe GitRepo do
  let(:config) { double }
  before { allow(config).to receive(:repos).and_return(repos) }

  let(:executor) { executor_double }
  let(:git_repo) { "zsh-users/zsh-syntax-highlighting" }
  let(:target) { "~/.zsh/zsh-syntax-highlighting" }
  let(:repos) { { git_repo => target } }

  subject { GitRepo.new(config, executor) }

  describe :install do
    it "should clone the repos provided when initialized from GitHub" do
      executor.should_receive(:execute).with("Cloning #{git_repo}", "git clone git@github.com:#{git_repo}.git #{target}")
      subject.install
    end

    it "should skip if the repo was already cloned" do
      executor.stub(:execute).and_yield "", "already exists and is not an empty directory"
      expect { subject.install }.to raise_exception(TaskSkipped, "Already cloned")
    end
  end

  describe :update do
    it "should pull the repos provided when initialized" do
      executor.should_receive(:execute).with("Pulling #{git_repo}", "cd #{target} && git pull")
      subject.update
    end
  end
end
