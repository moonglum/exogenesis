require 'tmpdir'
require 'spec_helper'
require 'exogenesis/passengers/fonts'

describe Fonts do

  let(:config) { double }

  before {
    temp_dir = Dir.mktmpdir
    FileUtils.touch File.join(temp_dir, 'roboto.ttf')
    FileUtils.touch File.join(temp_dir, 'bignoodle.otf')
    allow(config).to receive(:fonts_path).and_return(temp_dir)
  }

  let(:executor) { executor_double }
  subject { Fonts.new(config, executor) }

  after do
    FileUtils.remove_entry_secure config.fonts_path
  end

  describe :up do

    it 'should copy fonts if they are not found' do
      expect(executor).to receive(:execute)
        .with('Copying roboto.ttf', "cp '#{config.fonts_path}/roboto.ttf' '#{ENV['HOME']}/Library/Fonts/roboto.ttf'")
      expect(executor).to receive(:execute)
        .with('Copying bignoodle.otf', "cp '#{config.fonts_path}/bignoodle.otf' '#{ENV['HOME']}/Library/Fonts/bignoodle.otf'")
      subject.up
    end

    it 'should skip fonts if they are found' do
      expect(File).to receive(:exist?).and_return(true).twice
      expect(executor).to receive(:skip_task)
        .with('Copying roboto.ttf', 'Already copied')
      expect(executor).to receive(:skip_task)
        .with('Copying bignoodle.otf', 'Already copied')
      subject.up
    end
  end

  describe :down do

    it 'should remove the fonts if they are found' do
      expect(executor).to receive(:rm_rf)
        .with("#{ENV['HOME']}/Library/Fonts/roboto.ttf")
      expect(executor).to receive(:rm_rf)
        .with("#{ENV['HOME']}/Library/Fonts/bignoodle.otf")
      subject.down
    end

  end
end
