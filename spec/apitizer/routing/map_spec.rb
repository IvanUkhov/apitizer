require 'spec_helper'

RSpec.describe Apitizer::Routing::Map do
  extend ResourceHelper

  describe '#define' do
    it 'declares plain resources' do
      subject.define { resources(:articles) }
      path = subject.trace(:index, [ :articles ])
      expect(path.address).to eq('articles')
    end

    it 'declares nested resources' do
      subject.define { resources(:articles) { resources(:sections) } }
      path = subject.trace(:show, [ :articles, 'xxx', :sections, 'yyy' ])
      expect(path.address).to eq('articles/xxx/sections/yyy')
    end

    it 'declares the root address' do
      subject.define do
        address('https://service.com/api')
        resources(:articles)
      end
      path = subject.trace(:show, [ :articles, 'xxx' ])
      expect(path.address).to eq('https://service.com/api/articles/xxx')
    end

    restful_actions.each do |action|
      it "declares #{ action } operations on members" do
        subject.define do
          resources(:articles) { send(action, :shred, on: :member) }
        end
        path = subject.trace(action, [ :articles, 'xxx', :shred ])
        expect(path.address).to eq('articles/xxx/shred')
      end

      it "declares #{ action } operations on members with variable names" do
        subject.define do
          resources(:articles) { send(action, ':paragraph', on: :member) }
        end
        path = subject.trace(action, [ :articles, 'xxx', 'zzz' ])
        expect(path.address).to eq('articles/xxx/zzz')
      end

      it "declares #{ action } operations on collections" do
        subject.define do
          resources(:articles) { send(action, :shred, on: :collection) }
        end
        path = subject.trace(action, [ :articles, :shred ])
        expect(path.address).to eq('articles/shred')
      end

      it "declares #{ action } operations on collections with variable names" do
        subject.define do
          resources(:articles) { send(action, ':paragraph', on: :collection) }
        end
        path = subject.trace(action, [ :articles, 'zzz' ])
        expect(path.address).to eq('articles/zzz')
      end
    end

    it 'supports reopening of resource declarations' do
      subject.define do
        resources(:articles)
        resources(:articles) { resources(:sections) }
      end
      path = subject.trace(:show, [ :articles, 'xxx', :sections, 'yyy' ])
      expect(path.address).to eq('articles/xxx/sections/yyy')
    end
  end
end
