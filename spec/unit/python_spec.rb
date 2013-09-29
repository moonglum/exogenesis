require "spec_helper"
require "exogenesis/passengers/python"

describe Python do
  let(:config) { double}
  before { allow(config).to receive(:pips).and_return(pips) }

  let(:executor) { executor_double }
  let(:pips) { ["pygments"] }

  subject { Python.new(config, executor) }

  it_should_behave_like "a package manager",
    :with_section_name => :Python,
    :for => [:setup, :install, :update]

  describe :setup do
    it "should install python via homebrew and then link it with overwrite" do
      executor.should_receive(:execute).ordered.with("Install Python", "brew install python")
      executor.should_receive(:execute).ordered.with("Link Python", "brew link --overwrite python")
      subject.setup
    end

    it "should skip if python is already installed" do
      executor.stub(:execute).with("Install Python", "brew install python").and_yield "already installed"
      expect { subject.setup }.to raise_exception(TaskSkipped, "Already installed")
    end
  end

  describe :install do
    it "should install the pips provided when initialized" do
      executor.should_receive(:execute).with("Install pygments", "pip install --user pygments")
      subject.install
    end

    it "should skip if the package was already installed" do
      executor.stub(:execute).with("Install pygments", "pip install --user pygments").and_yield "already satisfied"
      expect { subject.install }.to raise_exception(TaskSkipped, "Already installed")
    end
  end

  describe :update do
    it "should update the pips provided when initialized" do
      executor.should_receive(:execute).with("Update pygments", "pip install --user --upgrade pygments")
      subject.update
    end

    it "should skip the package if it is already up to date" do
      executor.stub(:execute).with("Update pygments", "pip install --user --upgrade pygments").and_yield "already up-to-date"
      expect { subject.update }.to raise_exception(TaskSkipped, "Already up to date")
    end
  end
end
