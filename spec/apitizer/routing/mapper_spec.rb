require 'spec_helper'

describe Apitizer::Routing::Mapper do
  extend ResourceHelper

  let(:subject_module) { Apitizer::Routing }
  let(:subject_class) { Apitizer::Routing::Mapper }

  def create_request(action)
    Apitizer::Connection::Request.new(action: action)
  end

  describe '#define' do
    it 'declares plane resources' do
      subject.define { resources(:articles) }
      request = subject.trace(create_request(:index), [ :articles ])
      expect(request.address).to eq('articles')
    end

    it 'declares nested resources' do
      subject.define { resources(:articles) { resources(:sections) } }
      request = subject.trace(create_request(:show),
        [ :articles, 'xxx', :sections, 'yyy' ])
      expect(request.address).to eq('articles/xxx/sections/yyy')
    end

    it 'declares scoped resources' do
      subject.define do
        scope 'https://service.com/api' do
          scope [ 'v1', :json ] do
            resources(:articles) { resources(:sections) }
          end
        end
      end
      request = subject.trace(create_request(:show),
        [ :articles, 'xxx', :sections, 'yyy' ])
      expect(request.address).to eq(
        'https://service.com/api/v1/json/articles/xxx/sections/yyy')
    end

    restful_member_actions.each do |action|
      it "declares custom #{ action } operations on members" do
        subject.define do
          resources :articles do
            send(action, :operation, on: :member)
          end
        end
        request = subject.trace(create_request(action),
          [ :articles, 'xxx', :operation ])
        expect(request.address).to eq('articles/xxx/operation')
      end

      it 'declares custom operations with variable names' do
        subject.define do
          resources :articles do
            resources :sections do
              send(action, ':paragraph', on: :member)
            end
          end
        end
        request = subject.trace(create_request(action),
          [ :articles, 'xxx', :sections, 'yyy', 'zzz' ])
        expect(request.address).to eq('articles/xxx/sections/yyy/zzz')
      end
    end
  end

  describe '#trace' do
    shared_examples 'adequate resource tracer' do
      restful_member_actions.each do |action|
        it "assembles addresses of #{ action } Requests" do
          request = subject.trace(create_request(action),
            [ *subject_path, 'xxx' ])
          expect(request.address).to eq("#{ subject_address }/xxx")
        end
      end

      restful_collection_actions.each do |action|
        it "assembles addresses of #{ action } Requests" do
          request = subject.trace(create_request(action), subject_path)
          expect(request.address).to eq(subject_address)
        end
      end

      restful_member_actions.each do |action|
        it "raises exceptions for #{ action } actions to collections" do
          expect do
            subject.trace(create_request(action), subject_path)
          end.to raise_error(subject_module::Error, /Not permitted/i)
        end
      end

      restful_collection_actions.each do |action|
        it "raises exceptions for #{ action } actions to members" do
          expect do
            subject.trace(create_request(action), [ *subject_path, 'xxx' ])
          end.to raise_error(subject_module::Error, /Not permitted/i)
        end
      end
    end

    context 'when working with plain collections' do
      before(:each) do
        subject.define { resources(:articles) }
      end

      let(:subject_path) { [ :articles ] }
      let(:subject_address) { 'articles' }

      it_behaves_like 'adequate resource tracer'
    end

    context 'when working with nested collections' do
      before(:each) do
        subject.define do
          resources :articles do
            resources :sections
          end
        end
      end

      let(:subject_path) { [ :articles, 'yyy', :sections ] }
      let(:subject_address) { 'articles/yyy/sections' }

      it_behaves_like 'adequate resource tracer'
    end

    family_actions = [ :show, :update, :delete ]

    context "when only #{ family_actions.join(', ') } are allowed" do
      before(:each) do
        subject.define do
          resources :articles do
            resources :sections, only: family_actions
          end
        end
      end

      (restful_collection_actions - family_actions).each do |action|
        it "raises expections for #{ action } actions" do
          expect do
            subject.trace(create_request(action),
              [ :articles, 'xxx', :sections ])
          end.to raise_error(subject_module::Error, /Not permitted/i)
        end
      end

      (restful_member_actions - family_actions).each do |action|
        it "raises expections for #{ action } actions" do
          expect do
            subject.trace(create_request(action),
              [ :articles, 'xxx', :sections, 'yyy' ])
          end.to raise_error(subject_module::Error, /Not permitted/i)
        end
      end
    end

    restful_actions.each do |action|
      it "assembles addresses for custom #{ action } actions" do
        subject.define do
          resources :articles do
            send(action, :havefun, on: :member)
          end
        end
        request = subject.trace(create_request(action),
          [ :articles, 'xxx', :havefun ])
        expect(request.address).to eq('articles/xxx/havefun')
      end
    end

    it 'does not support reopening of resource declarations' do
      subject.define do
        resources :articles
        resources :articles do
          resources :sections
        end
      end
      expect do
        subject.trace(create_request(:show),
          [ :articles, 'xxx', :sections, 'yyy' ])
      end.to raise_error(subject_module::Error, /Not found/i)
    end
  end
end
