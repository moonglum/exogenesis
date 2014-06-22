require 'spec_helper'
require 'exogenesis/passengers/git_repo'

describe GitRepo do
  let(:git_repo) { double('GitRepository') }
  let(:target) { double('Target') }
  let(:target_path) { double('TargetPath') }
  let(:repos) { { git_repo => target } }

  let(:config) { double }
  before { allow(config).to receive(:repos).and_return(repos) }

  let(:executor) { executor_double }
  before { allow(executor).to receive(:get_path_for).with(target).and_return(target_path) }

  subject { GitRepo.new(config, executor) }

  describe :up do
    context 'path exists' do
      before { allow(target_path).to receive(:exist?).and_return true }

      it 'should pull the repo' do
        expect(executor).to receive(:pull_repo).with(git_repo, target_path)
        subject.up
      end
    end

    context 'path does not exist' do
      before { allow(target_path).to receive(:exist?).and_return false }

      it 'should clone the repo' do
        expect(executor).to receive(:clone_repo).with(git_repo, target_path)
        subject.up
      end
    end
  end

  describe :down do
    it 'should `rm_rf` the repo' do
      expect(executor).to receive(:rm_rf).with(target_path)
      subject.down
    end
  end
end
