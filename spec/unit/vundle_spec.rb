require 'spec_helper'
require 'exogenesis/passengers/vundle'

describe Vundle do
  let(:config) { double }
  let(:executor) { executor_double }

  let(:vundle_folder) { double('VundleFolder', to_s: 'VUNDLE_FOLDER') }

  subject { Vundle.new(config, executor) }

  describe :up do
    before { allow(executor).to receive('get_path_in_home').with('.vim', 'bundle', 'vundle').and_return(vundle_folder) }
    before { allow(vundle_folder).to receive('exist?').and_return(true) }

    describe 'install Vundle if necessary' do
      context 'vundle folder exists' do
        before { allow(vundle_folder).to receive('exist?').and_return(true) }

        it 'should skip cloning vundle' do
          expect(executor).to receive(:skip_task).with('Cloning Vundle')
          subject.up
        end

        it 'should not clone vundle' do
          expect(executor).to_not receive(:execute).with(anything, 'git clone git://github.com/gmarik/vundle.git VUNDLE_FOLDER').ordered
          subject.up
        end
      end

      context 'vundle folder does not exist' do
        before { allow(vundle_folder).to receive('exist?').and_return(false) }

        it 'should make a path and clone vundle' do
          expect(executor).to receive(:mkpath).with(vundle_folder).ordered
          expect(executor).to receive(:execute).with('Cloning Vundle', 'git clone git://github.com/gmarik/vundle.git VUNDLE_FOLDER').ordered
          subject.up
        end
      end
    end

    it 'should install and update bundles' do
      expect(executor).to receive(:execute_interactive).with('Installing and Updating Vim Bundles', 'vim +BundleInstall\! +qall')
      subject.up
    end
  end

  describe :down do
    it 'should remove the vundle repo' do
      allow(executor).to receive(:get_path_in_home).with('.vim').and_return('/Users/muse/.vim')
      expect(executor).to receive(:rm_rf).with('/Users/muse/.vim')
      subject.down
    end
  end

  describe :clean do
    it 'should interactively execute BundleClean' do
      executor.should_receive(:execute_interactive).with('Cleaning', 'vim +BundleClean\! +qall')
      subject.clean
    end
  end
end
