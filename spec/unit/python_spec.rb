require "spec_helper"
require "exogenesis/passengers/python"

describe Python do
  let(:config) { double}
  before { allow(config).to receive(:pips).and_return(required_pips) }
  let(:executor) { executor_double }

  subject { Python.new(config, executor) }

  describe :up do
    before do
      allow(executor).to receive(:command_exists?).and_return(true)
      allow(executor).to receive(:silent_execute).with('pip list').and_return(installed_pips)
    end

    let(:required_pips) { ['pygments', 'buildbot'] }
    let(:installed_pips) { "buildbot (0.8.8)\nbuildbot-slave (0.8.8)" }

    describe 'installing Python' do
      context 'when pip already exists' do
        before { allow(executor).to receive(:command_exists?).and_return(true) }

        it 'should skip installing Python' do
          expect(executor).to receive(:skip_task).with('Install Python')
          subject.up
        end

        it 'should not install Python via brew' do
          expect(executor).to_not receive(:execute).with('Install Python', 'brew install python')
          subject.up
        end
      end

      context 'when pip does not exist' do
        before { allow(executor).to receive(:command_exists?).and_return(false) }

        it 'should install Python via brew' do
          expect(executor).to receive(:execute).with('Install Python', 'brew install python')
          subject.up
        end
      end
    end

    describe 'link Python' do
      it 'should link Python' do
        expect(executor).to receive(:execute).with('Link Python', 'brew link --overwrite python')
        subject.up
      end

      it 'should skip the task if it is already linked' do
        allow(executor).to receive(:execute).with('Link Python', 'brew link --overwrite python').and_yield('Warning: Already linked: /usr/local/Cellar/python/2.7.6')
        expect { subject.up }.to raise_exception(TaskSkipped, 'Already linked')
      end
    end

    describe 'installing and updating pips' do
      it 'should update pip itself'
      it 'should update installed pips' # Update buildbot
      it 'should install missing pips'  # Install pygments
      it 'should skip the update if it is up to date'
    end
  end
end
