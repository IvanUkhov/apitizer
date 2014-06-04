require 'spec_helper'

RSpec.describe Apitizer::Routing::Path do
  extend ResourceHelper
  include FactoryHelper

  describe '#<<' do
    it 'builds up addresses' do
      [ :articles, 'xxx', :sections, 'yyy' ].each { |step| subject << step }
      expect(subject.address).to eq('articles/xxx/sections/yyy')
    end
  end

  describe '#advance' do
    it 'keeps track of destinations' do
      nodes = [ double('articles'), double('sections') ]
      nodes.each { |node| subject.advance(node) }
      expect(subject.node).to be(nodes.last)
    end
  end

  shared_examples 'an adequate guard' do |only_actions: restful_actions|
    (restful_collection_actions & only_actions).each do |action|
      it "is true for #{ action } collection action" do
        path = root.trace(steps)
        expect(path.permitted?(action)).to be true
      end
    end

    (restful_member_actions & only_actions).each do |action|
      it "is true for #{ action } member actions" do
        path = root.trace([ *steps, 'xxx' ])
        expect(path.permitted?(action)).to be true
      end
    end

    (restful_collection_actions - only_actions).each do |action|
      it "is false for #{ action } collection action" do
        path = root.trace(steps)
        expect(path.permitted?(action)).to be false
      end
    end

    (restful_member_actions - only_actions).each do |action|
      it "is false for #{ action } member actions" do
        path = root.trace([ *steps, 'xxx' ])
        expect(path.permitted?(action)).to be false
      end
    end

    restful_member_actions.each do |action|
      it "is false for #{ action } actions to collections" do
        path = root.trace(steps)
        expect(path.permitted?(action)).to be false
      end
    end

    restful_collection_actions.each do |action|
      it "is false for #{ action } actions to members" do
        path = root.trace([ *steps, 'xxx' ])
        expect(path.permitted?(action)).to be false
      end
    end
  end

  describe '#permitted?' do
    context 'when working with plain collections' do
      let(:root) { create_tree(:articles) }
      let(:steps) { [ :articles ] }

      it_behaves_like 'an adequate guard'
    end

    context 'when working with nested collections' do
      let(:root) { create_tree(:articles, :sections) }
      let(:steps) { [ :articles, 'yyy', :sections ] }

      it_behaves_like 'an adequate guard'
    end

    context 'when working with collections restricted to index and show' do
      let(:root) { create_tree([ :articles, [ :index, :show ] ]) }
      let(:steps) { [ :articles ] }

      it_behaves_like 'an adequate guard', only_actions: [ :index, :show ]
    end

    restful_member_actions.each do |action|
      it "is true for custom #{ action } operations on members" do
        root = create_tree(:articles, shred: action)
        path = root.trace([ :articles, 'xxx', :shred ])
        expect(path.permitted?(action)).to be true
      end

      it "is true for custom #{ action } operations with variable names" do
        root = create_tree(:articles, ':paragraph' => action)
        path = root.trace([ :articles, 'xxx', 'zzz' ])
        expect(path.permitted?(action)).to be true
      end
    end
  end
end
