require 'spec_helper'
require 'exogenesis/passengers/vim_plug'

describe VimPlug do
  let(:config) { double }
  let(:executor) { executor_double }

  subject { VimPlug.new(config, executor) }

  describe :up do
    it 'should install and update plugins' do
      expect(executor).to receive(:execute_interactive).with('Installing and Updating Vim plugins', 'vim +PlugUpdate\! +qall')
      subject.up
    end
  end

  describe :clean do
    it 'should interactively execute BundleClean' do
      executor.should_receive(:execute_interactive).with('Cleaning', 'vim +PlugClean\! +qall')
      subject.clean
    end
  end
end
