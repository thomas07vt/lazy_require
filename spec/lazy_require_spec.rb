require 'spec_helper'

describe LazyRequire do
  it 'has a version number' do
    expect(LazyRequire::VERSION).not_to be nil
  end

  describe '#require' do

    it 'accepts one or more files' do
      expect { LazyRequire.require('./spec/support/two.rb') }.to_not raise_error
      expect { Two.new }.to_not raise_error
    end

    it 'accepts an array' do
      expect { LazyRequire.require(['./spec/support/two_child.rb']) }.to_not raise_error
      expect { TwoChild.new }.to_not raise_error
    end

    context 'when the loading order is correct' do
      before do
        @files = [
          './spec/support/one.rb',
          './spec/support/one_child.rb',
          './spec/support/one_child_child.rb',
        ]
      end

      it 'loads all files' do
        expect { LazyRequire.require(@files) }.to_not raise_error
        expect {One.new; OneChild.new; OneChildChild.new }.to_not raise_error
      end
    end

    context 'when the loading order is not correct' do
      before do
        @files = [
          './spec/support/three_child_child.rb',
          './spec/support/three_child.rb',
          './spec/support/three.rb',
        ]
      end

      it 'loads all files' do
        expect { LazyRequire.require(@files) }.to_not raise_error
        expect {Three.new; ThreeChild.new; ThreeChildChild.new }.to_not raise_error
      end
    end

    context 'when a dependency does not exist' do
      before do
        @files = [
          './spec/support/errors/top_two.rb',
          './spec/support/errors/top.rb',
        ]
      end

      it 'raises and exception' do
        expect { LazyRequire.require(@files) }.to raise_error(NameError)
      end
    end

  end

  describe '#require_all' do
    before do
      @files = Dir['./spec/support/load_all/**/*.rb']
      allow(LazyRequire).to receive(:require).and_return(true)
    end

    it 'sends all files from glob to #require()' do
      expect(LazyRequire).to receive(:require).with(@files)
      LazyRequire.require_all('./spec/support/load_all/**/*.rb')
    end

  end

  describe 'overriding the require method' do
    it 'only overides the require method on the LazyRequire object' do
      expect(LazyRequire.method(:require).owner).to_not eq(Kernel)
      expect(method(:require).owner).to eq(Kernel)
    end
  end

end

