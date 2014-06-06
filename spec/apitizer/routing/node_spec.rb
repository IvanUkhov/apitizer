require 'spec_helper'

RSpec.describe Apitizer::Routing::Node do
  extend ResourceHelper
  include FactoryHelper

  shared_examples 'an adequate pathfinder' do
    it 'finds final destinations' do
      expect(root.trace(steps)).to be_kind_of(Apitizer::Routing::Path)
    end
  end

  shared_examples 'an adequate collection guard' do |only: restful_actions|
    (restful_collection_actions & only).each do |action|
      it "permits #{ action } actions" do
        path = root.trace(steps)
        expect(path.permit?(action)).to be_truthy
      end
    end

    (restful_collection_actions - only).each do |action|
      it "does not permit #{ action } actions" do
        path = root.trace(steps)
        expect(path.permit?(action)).to be_falsy
      end
    end

    restful_member_actions.each do |action|
      it "does not permit #{ action } actions" do
        path = root.trace(steps)
        expect(path.permit?(action)).to be_falsy
      end
    end
  end

  shared_examples 'an adequate member guard' do |only: restful_actions|
    (restful_member_actions & only).each do |action|
      it "permites #{ action } actions" do
        path = root.trace(steps)
        expect(path.permit?(action)).to be_truthy
      end
    end

    (restful_member_actions - only).each do |action|
      it "does not permit #{ action } actions" do
        path = root.trace(steps)
        expect(path.permit?(action)).to be_falsy
      end
    end

    restful_collection_actions.each do |action|
      it "does not permit #{ action } actions" do
        path = root.trace(steps)
        expect(path.permit?(action)).to be_falsy
      end
    end
  end

  context 'when defining plain collections' do
    let(:root) { create_tree(:articles) }

    context 'when looking for collections' do
      let(:steps) { [ :articles ] }
      it_behaves_like 'an adequate pathfinder'
      it_behaves_like 'an adequate collection guard'
    end

    context 'when looking for members' do
      let(:steps) { [ :articles, 'xxx' ] }
      it_behaves_like 'an adequate pathfinder'
      it_behaves_like 'an adequate member guard'
    end
  end

  context 'when defining nested collections' do
    let(:root) { create_tree(:articles, :sections) }
    let(:steps) { [ :articles, 'yyy', :sections ] }

    context 'when looking for collections' do
      let(:steps) { [ :articles, 'xxx', :sections ] }
      it_behaves_like 'an adequate pathfinder'
      it_behaves_like 'an adequate collection guard'
    end

    context 'when looking for members' do
      let(:steps) { [ :articles, 'xxx', :sections, 'yyy' ] }
      it_behaves_like 'an adequate pathfinder'
      it_behaves_like 'an adequate member guard'
    end
  end

  only = [ :index, :show ]
  context "when defining collections restricted to #{ only.join(', ') }" do
    let(:root) { create_tree([ :articles, only ]) }

    context 'when looking for collections' do
      let(:steps) { [ :articles ] }
      it_behaves_like 'an adequate pathfinder'
      it_behaves_like 'an adequate collection guard', only: only
    end

    context 'when looking for members' do
      let(:steps) { [ :articles, 'xxx' ] }
      it_behaves_like 'an adequate pathfinder'
      it_behaves_like 'an adequate member guard', only: only
    end
  end

  restful_actions.each do |action|
    context "when defining #{ action } operations" do
      let(:root) { create_tree(:articles, shred: action) }
      let(:steps) { [ :articles, 'xxx', :shred ] }

      it_behaves_like 'an adequate pathfinder'
    end
  end

  restful_collection_actions.each do |action|
    context "when defining #{ action } operations with varible names" do
      let(:root) { create_tree(:articles, ':paragraph' => action) }
      let(:steps) { [ :articles, 'zzz' ] }

      it_behaves_like 'an adequate pathfinder'
    end
  end

  restful_member_actions.each do |action|
    context "when defining #{ action } operations with varible names" do
      let(:root) { create_tree(:articles, ':paragraph' => action) }
      let(:steps) { [ :articles, 'xxx', 'zzz' ] }

      it_behaves_like 'an adequate pathfinder'
    end
  end
end
