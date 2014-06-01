require 'spec_helper'

describe Apitizer::Routing::Path do
  extend ResourceHelper

  def create_mapper(&block)
    Apitizer::Routing::Mapper.new(&block)
  end

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

  an_adequate_guard = Proc.new do |only_actions = restful_actions|
    (restful_collection_actions & only_actions).each do |action|
      it "is true for #{ action } collection action" do
        path = mapper.trace(steps)
        expect(path.permitted?(action)).to be_true
      end
    end

    (restful_member_actions & only_actions).each do |action|
      it "is true for #{ action } member actions" do
        path = mapper.trace([ *steps, 'xxx' ])
        expect(path.permitted?(action)).to be_true
      end
    end

    (restful_collection_actions - only_actions).each do |action|
      it "is false for #{ action } collection action" do
        path = mapper.trace(steps)
        expect(path.permitted?(action)).to be_false
      end
    end

    (restful_member_actions - only_actions).each do |action|
      it "is false for #{ action } member actions" do
        path = mapper.trace([ *steps, 'xxx' ])
        expect(path.permitted?(action)).to be_false
      end
    end

    restful_member_actions.each do |action|
      it "is false for #{ action } actions to collections" do
        path = mapper.trace(steps)
        expect(path.permitted?(action)).to be_false
      end
    end

    restful_collection_actions.each do |action|
      it "is false for #{ action } actions to members" do
        path = mapper.trace([ *steps, 'xxx' ])
        expect(path.permitted?(action)).to be_false
      end
    end
  end

  describe '#permitted?' do
    context 'when working with plain collections' do
      let(:mapper) { create_mapper { resources(:articles) } }
      let(:steps) { [ :articles ] }

      instance_exec(&an_adequate_guard)
    end

    context 'when working with nested collections' do
      let(:mapper) do
        create_mapper { resources(:articles) { resources(:sections) } }
      end
      let(:steps) { [ :articles, 'yyy', :sections ] }

      instance_exec(&an_adequate_guard)
    end

    context 'when working with collections restricted to index and show' do
      let(:mapper) do
        create_mapper { resources(:articles, only: [ :index, :show ]) }
      end
      let(:steps) { [ :articles ] }

      instance_exec([ :index, :show ], &an_adequate_guard)
    end

    restful_member_actions.each do |action|
      it "is true for custom #{ action } operations on members" do
        mapper = create_mapper do
          resources(:articles) { send(action, :operation, on: :member) }
        end
        path = mapper.trace([ :articles, 'xxx', :operation ])
        expect(path.permitted?(action)).to be_true
      end

      it "is true for custom #{ action } operations with variable names" do
        mapper = create_mapper do
          resources(:articles) { send(action, ':paragraph', on: :member) }
        end
        path = mapper.trace([ :articles, 'xxx', 'zzz' ])
        expect(path.permitted?(action)).to be_true
      end
    end
  end
end
