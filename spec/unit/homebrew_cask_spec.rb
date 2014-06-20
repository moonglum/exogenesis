require 'spec_helper'
require 'exogenesis/passengers/homebrew_cask'

describe HomebrewCask do
  let(:casks) { ['firefox', 'cow'] }

  let(:config) { double }
  before { allow(config).to receive(:casks).and_return(casks) }

  let(:executor) { executor_double }

  subject { HomebrewCask.new(config, executor) }

  describe :up do
    before do
      allow(executor).to receive(:silent_execute).with('brew tap').
        and_return("caskroom/cask\n")
      allow(executor).to receive(:silent_execute).with('brew cask list').
        and_return("vlc\nfirefox")
    end

    describe 'set up homebrew cask' do
      context 'cask is tapped' do
        it 'should not attempt to tap cask' do
          expect(executor).to_not receive(:execute_interactive).
            with('Tap Cask', anything)
          subject.up
        end
      end

      context 'cask is not tapped' do
        before do
          allow(executor).to receive(:silent_execute).with('brew tap').
            and_return('')
        end

        it 'should tap cask' do
          expect(executor).to receive(:execute_interactive).
            with('Tap Cask', 'brew tap caskroom/cask')
          subject.up
        end
      end
    end

    describe 'install missing casks' do
      it 'should install the missing cask' do
        expect(executor).to receive(:execute).
          with('Installing cow', /\Abrew cask install cow\s*\z/)
        subject.up
      end

      it 'should not install the already installed cask' do
        expect(executor).to_not receive(:execute).
          with('Installing firefox', anything)
        subject.up
      end
    end

  end

  describe :clean do
    it 'should cleanup the cask cache' do
      expect(executor).to receive(:execute).
        with('Clean Up', 'brew cask cleanup')
      subject.clean
    end
  end

  describe :down do
    before do
      allow(executor).to receive(:silent_execute).with('brew tap').
        and_return("caskroom/cask\n")
      allow(executor).to receive(:silent_execute).with('brew cask list').
        and_return("vlc\nfirefox")
    end

    it 'should uninstall installed casks' do
      expect(executor).to receive(:execute).
        with('Uninstalling firefox', 'brew cask uninstall firefox')
      expect(executor).to receive(:execute).
        with('Uninstalling vlc', 'brew cask uninstall vlc')
      subject.down
    end

    it 'should untap cask' do
      expect(executor).to receive(:execute).
        with('Untap Cask', 'brew untap caskroom/cask')
      subject.down
    end
  end
end
