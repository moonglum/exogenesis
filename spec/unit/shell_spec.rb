require 'spec_helper'
require 'exogenesis/passengers/shell'

describe Shell do
  let(:config) { double }
  let(:commands) { ['echo "hello world"'] }

  before {
    allow(config).to receive(:commands).and_return(commands)
  }

  let(:executor) { executor_double }

  subject { Shell.new(config, executor) }

  describe :up do
    it 'should succeed if exit code is equal 0' do
      expect(executor).to receive(:execute)
        .with('Executing command `echo "hello world"`', 'echo "hello world"')
      subject.up
    end
  end
end
