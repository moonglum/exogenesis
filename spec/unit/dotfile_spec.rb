require "spec_helper"
require "exogenesis/passengers/dotfile"

describe Dotfile do
  let(:directory_name) { 'tilde' }
  let(:config) { double }
  before { allow(config).to receive(:directory_name).and_return(directory_name) }

  let(:executor) { executor_double }

  subject { Dotfile.new(config, executor) }

  let(:source_directory) { double('SourceDirectory', entries: [source_vimrc] ) }
  let(:source_vimrc) { double('SourceVimrc', basename: 'vimrc') }
  let(:target_vimrc) { double('TargetVimrc') }

  before do
    allow(executor).to receive(:get_path_in_working_directory)
      .with(directory_name)
      .and_return(source_directory)
    allow(executor).to receive(:get_path_in_home)
      .with('.vimrc')
      .and_return(target_vimrc)
    allow(source_directory).to receive(:each_child).and_yield(source_vimrc)
  end

  describe :up do
    it 'should ln_s from the source to the destination' do
      expect(executor).to receive(:ln_s).with(source_vimrc, target_vimrc)
      subject.up
    end
  end

  describe :down do
    it 'should rm_rf the destination' do
      expect(executor).to receive(:rm_rf).with(target_vimrc)
      subject.down
    end
  end
end
