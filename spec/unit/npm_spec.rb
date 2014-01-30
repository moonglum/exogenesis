require "spec_helper"
require "exogenesis/passengers/npm"

describe Npm do
  let(:config) { double}
  before { allow(config).to receive(:npms).and_return(npms) }

  let(:executor) { executor_double }
  let(:npms) { ["buster"] }

  subject { Npm.new(config, executor) }

  describe :setup do
    it "should install npm via homebrew and then link it with overwrite" do
      executor.should_receive(:execute).ordered.with("Install npm", "brew install npm")
      subject.setup
    end

    it "should skip if npm is already installed" do
      executor.stub(:execute).with("Install npm", "brew install npm").and_yield "already installed"
      expect { subject.setup }.to raise_exception(TaskSkipped, "Already installed")
    end
  end

  describe :install do
    it "should install the npms provided when initialized" do
      executor.should_receive(:execute).with("Install buster", "npm install -g buster")
      subject.install
    end
  end

  describe :update do
    it "should update the npms provided when initialized" do
      executor.should_receive(:execute).with("Update buster", "npm update -g buster")
      subject.update
    end
  end
end
