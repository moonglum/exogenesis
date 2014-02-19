# -*- encoding : utf-8 -*-
require "spec_helper"
require "exogenesis/passengers/npm"

describe Npm do
  let(:config) { double}
  before { allow(config).to receive(:npms).and_return(npms) }

  let(:executor) { executor_double }
  let(:npms) { ['bower', 'buster'] }

  let(:raw_installed) { "/usr/local/share/npm/lib\n├── bower@1.2.8\n├── docco@0.6.3" }

  subject { Npm.new(config, executor) }

  describe :up do
    before { allow(executor).to receive(:silent_execute).with('npm ls -g --depth=0').and_return(raw_installed) }

    describe 'install Node if necessary' do
      context 'when npm command was not found' do
        before { allow(executor).to receive(:command_exists?).with('npm').and_return(false) }

        it 'should install node via homebrew' do
          expect(executor).to receive(:execute).with('Install Node', 'brew install node')
          subject.up
        end
      end

      context 'when npm command was found' do
        before { allow(executor).to receive(:command_exists?).with('npm').and_return(true) }

        it 'should not install node via homebrew' do
          expect(executor).to_not receive(:execute).with('Install Node', 'brew install node')
          subject.up
        end

        it 'should indicate that it skipped installing Node' do
          expect(executor).to receive(:skip_task).with('Install Node')
          subject.up
        end
      end
    end

    describe 'install or update packages' do
      before { allow(executor).to receive(:command_exists?).with('npm').and_return(true) }

      it 'should install missing packages' do
        executor.should_receive(:execute).with('Install buster', 'npm install -g buster')
        subject.up
      end

      it 'should update installed packages' do
        executor.should_receive(:execute).with('Update bower', 'npm update -g bower')
        subject.up
      end
    end
  end
end
