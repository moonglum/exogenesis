require "spec_helper"
require "exogenesis/passengers/homebrew"

describe Homebrew do
  let(:brews) { ['vim', 'chicken'] }

  let(:config) { double }
  before { allow(config).to receive(:brews).and_return(brews) }

  let(:executor) { executor_double }

  subject { Homebrew.new(config, executor) }

  describe :up do
    before do
      allow(executor).to receive(:silent_execute).with('brew ls').and_return("  vim\n  emacs")
      allow(executor).to receive(:silent_execute).with('brew outdated').and_return("")
    end

    describe 'set up homebrew' do
      context 'brew is available' do
        before { allow(executor).to receive(:command_exists?).and_return(true) }

        it 'should not attempt to install homebrew' do
          expect(executor).to_not receive(:execute_interactive)
            .with('Install Homebrew', anything)
          subject.up
        end
      end

      context 'brew is not available' do
        before { allow(executor).to receive(:command_exists?).and_return(false) }

        it 'should install homebrew' do
          expect(executor).to receive(:execute_interactive)
            .with('Install Homebrew', 'ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"')
          subject.up
        end
      end
    end

    describe 'install missing brews' do
      it 'should install the missing package' do
        expect(executor).to receive(:execute).with('Installing chicken', /\Abrew install chicken\s*\z/)
        subject.up
      end

      it 'should not install the already installed package' do
        expect(executor).to_not receive(:execute).with('Installing vim', /\Abrew install vim\s*\z/)
        subject.up
      end

      it 'should pass on the options if it has any' do
        allow(config).to receive(:brews).and_return([ { chicken: ['option'] } ])
        expect(executor).to receive(:execute).with('Installing chicken', /\Abrew install chicken option\s*\z/)
        subject.up
      end
    end

    describe 'update outdated brews' do
      it 'should update homebrew' do
        expect(executor).to receive(:execute).with('Updating Homebrew', 'brew update')
        subject.up
      end

      context 'no package is outdated' do
        it 'should inform the user that all packages are up to date' do
          expect(executor).to receive(:skip_task).with('Upgrade Brews')
          subject.up
        end

        it 'should not execute brew upgrade' do
          expect(executor).to_not receive(:execute).with('Upgrade Brews', 'brew upgrade')
          subject.up
        end
      end

      context 'a package is outdated' do
        before { allow(executor).to receive(:silent_execute).with('brew outdated').and_return("vim") }

        it 'should inform the user about the outdated packages' do
          expect(executor).to receive(:info).with('Outdated Brews', 'vim')
          subject.up
        end

        it 'should execute brew upgrade' do
          expect(executor).to receive(:execute).with('Upgrade Brews', 'brew upgrade')
          subject.up
        end
      end
    end
  end

  describe :clean do
    it 'should execute the cleanup task from homebrew' do
      expect(executor).to receive(:execute).with('Clean Up', 'brew cleanup')
      subject.clean
    end
  end

  describe :down do
    it 'should execute the teardown script from mxcl' do
      expect(executor).to receive(:execute).with('Teardown', '\\curl -L https://gist.github.com/mxcl/1173223/raw/a833ba44e7be8428d877e58640720ff43c59dbad/uninstall_homebrew.sh | bash -s')
      subject.down
    end
  end
end
