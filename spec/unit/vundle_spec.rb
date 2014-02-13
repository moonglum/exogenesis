require "spec_helper"
require "exogenesis/passengers/vundle"

describe Vundle do
  let(:config) { double }

  let(:executor) { executor_double }

  subject { Vundle.new(config, executor) }

  describe :setup do
    it "should git clone the vundle repo" do
      executor.stub(:create_path_in_home).with(".vim", "bundle", "vundle").and_return "/Users/muse/.vim/bundle/vundle"
      executor.should_receive(:execute).with("Cloning Vundle",
        "git clone git://github.com/gmarik/vundle.git /Users/muse/.vim/bundle/vundle")
      subject.setup
    end

    it "should skip the task if the error output contains 'already exists'" do
      executor.stub(:execute).and_yield("", "already exists")
      expect { subject.setup }.to raise_exception(TaskSkipped, "Already exists")
    end
  end

  describe :install do
    it "should interactively execute BundleInstall and BundleClean" do
      executor.should_receive(:execute_interactive).with("Install", "vim +BundleInstall\! +qall")
      executor.should_receive(:execute_interactive).with("Clean", "vim +BundleClean\! +qall")
      subject.install
    end
  end

  describe :teardown do
    it "should remove the vundle repo" do
      executor.stub(:get_path_in_home).with(".vim").and_return("/Users/muse/.vim")
      executor.should_receive(:execute).with("Removing Vim Folder",
        "rm -r /Users/muse/.vim")
      subject.teardown
    end

    it "should skip the task if the output contains 'No such file or directory'" do
      executor.stub(:execute).and_yield("No such file or directory")
      expect { subject.teardown }.to raise_exception(TaskSkipped, "Folder not found")
    end
  end

  describe :update do
    it "should interactively execute BundleUpdate" do
      executor.should_receive(:execute_interactive).with("Updating Vim Bundles", "vim +BundleInstall! +qall")
      subject.update
    end
  end

  describe :clean do
    it "should interactively execute BundleClean" do
      executor.should_receive(:execute_interactive).with("Cleaning", "vim +BundleClean\! +qall")
      subject.clean
    end
  end
end
