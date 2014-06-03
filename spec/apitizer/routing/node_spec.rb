require 'spec_helper'

describe Apitizer::Routing::Node do
  extend ResourceHelper
  include FactoryHelper

  shared_examples 'an adequate pathfinder' do
    let(:path) { double(:<< => nil, :advance => nil) }

    it 'gradually builds up Paths' do
      steps.each do |step|
        expect(path).to receive(:<<).once.ordered.with(step)
      end
      root.trace(steps, path)
    end

    it 'gradually advances Paths' do
      expect(path).to receive(:advance).once.ordered # root
      steps.select { |step| step.is_a?(Symbol) }.each do |name|
        expect(path).to receive(:advance).once.ordered do |node|
          expect(node.match(name)).to be true
        end
      end
      root.trace(steps, path)
    end
  end

  describe '::Base#trace' do
    context 'when working with plain collections' do
      let(:root) { create_tree(:articles) }

      context 'when looking for collections' do
        let(:steps) { [ :articles ] }
        it_behaves_like 'an adequate pathfinder'
      end

      context 'when looking for members' do
        let(:steps) { [ :articles, 'xxx' ] }
        it_behaves_like 'an adequate pathfinder'
      end
    end

    context 'when working with nested collections' do
      let(:root) { create_tree(:articles, :sections) }

      context 'when looking for collections' do
        let(:steps) { [ :articles, 'xxx', :sections ] }
        it_behaves_like 'an adequate pathfinder'
      end

      context 'when looking for members' do
        let(:steps) { [ :articles, 'xxx', :sections, 'yyy' ] }
        it_behaves_like 'an adequate pathfinder'
      end
    end

    restful_actions.each do |action|
      context "when working with custom #{ action } actions" do
        let(:root) { create_tree(:articles, shred: action) }
        let(:steps) { [ :articles, 'xxx', :shred ] }
        it_behaves_like 'an adequate pathfinder'
      end
    end
  end
end
