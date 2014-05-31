require 'spec_helper'

describe Apitizer::Base do
  extend ResourceHelper

  let(:subject_class) { Apitizer::Base }
  let(:address) { 'https://service.com/api' }

  def stub_request(method, address)
    stub_http_request(method, "https://service.com/api/#{ address }").
      to_return(code: '200', body: '{}')
  end

  describe '#new' do
    it 'does not require any arguments' do
      expect { subject_class.new }.not_to raise_error
    end

    it 'draws a routing map when a block is given' do
      scope_name = address
      subject = subject_class.new { scope(scope_name) { resources(:articles) } }
      stub_request(:get, 'articles')
      expect { subject.process(:index, :articles) }.not_to raise_error
    end
  end

  describe '#process' do
    subject do
      scope_name = address
      subject_class.new { scope(scope_name) { resources(:articles) } }
    end

    restful_collection_actions.each do |action|
      method = rest_http_dictionary[action]

      it "is capable of #{ action } actions" do
        stub_request(method, 'articles')
        expect { subject.process(action, :articles) }.not_to raise_error
      end

      it "is capable of #{ action } actions via alias" do
        stub_request(method, 'articles')
        expect { subject.send(action, :articles) }.not_to raise_error
      end
    end

    restful_member_actions.each do |action|
      method = rest_http_dictionary[action]

      it "is capable of #{ action } actions" do
        stub_request(method, 'articles/xxx')
        expect { subject.process(action, :articles, 'xxx') }.not_to raise_error
      end

      it "is capable of #{ action } actions via alias" do
        stub_request(method, 'articles/xxx')
        expect { subject.send(action, :articles, 'xxx') }.not_to raise_error
      end
    end
  end
end
