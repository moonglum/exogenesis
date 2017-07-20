require 'spec_helper'
require 'exogenesis/passengers/rvm'

describe Rvm do
  let(:rubies) { ['ruby-1.9.3', 'ruby-2.0.0'] }
  let(:config) { double('Config', rubies: rubies) }
  let(:executor) { executor_double }

  let(:rvm_list_output) { "rvm rubies\n\nruby-2.0.0-p353 [ x86_64 ]\n=* ruby-2.1.0 [ x86_64 ]\n\n# => - current\n# # =* - current && default\n# #  * - default" }

  subject { Rvm.new(config, executor) }

  describe :up do
    before do
      allow(executor).to receive(:command_exists?).and_return(true)
      allow(executor).to receive(:execute).with(anything, 'rvm list').and_yield(rvm_list_output)
    end

    describe 'install RVM if necessary' do
      context 'when RVM does exist' do
        before { allow(executor).to receive(:command_exists?).and_return(false) }

        it 'should execute the RVM setup' do
          expect(executor).to receive(:execute_interactive).with('Setup', '\\curl -L https://get.rvm.io | bash -s')
          subject.up
        end
      end

      context 'when RVM does not exist' do
        it 'should skip the task' do
          expect(executor).to receive(:skip_task).with('Setup')
          subject.up
        end

        it 'should not execute the RVM setup' do
          expect(executor).to_not receive(:execute_interactive).with('Setup', '\\curl -L https://get.rvm.io | bash -s')
          subject.up
        end
      end
    end

    it 'should update RVM' do
      expect(executor).to receive(:execute).with('Update', 'rvm get head')
      subject.up
    end

    describe 'install or update rubies' do
      it 'should install a missing Ruby' do
        expect(executor).to receive(:execute).with('Installing ruby-1.9.3', 'rvm install ruby-1.9.3')
        subject.up
      end

      it 'should update an installed Ruby' do
        expect(executor).to receive(:execute).with('Upgrading ruby-2.0.0', 'rvm upgrade ruby-2.0.0-p353 ruby-2.0.0 --force')
        subject.up
      end

      it 'should skip the update of an installed Ruby if already installed' do
        allow(executor).to receive(:execute)
          .with('Upgrading ruby-2.0.0', 'rvm upgrade ruby-2.0.0-p353 ruby-2.0.0 --force')
          .and_yield(nil, "Source and Destination Ruby are the same (ruby-2.0.0-p353)\nError migrating gems.")

        expect { subject.up }.to raise_exception(TaskSkipped, 'Already Up to Date')
      end
    end

    it 'should reload RVM' do
      expect(executor).to receive(:execute).with('Reload', 'rvm reload')
      subject.up
    end
  end

  describe :down do
    it 'should implode RVM' do
      expect(executor).to receive(:execute_interactive).with('Teardown', 'rvm implode')
      subject.down
    end
  end
end
