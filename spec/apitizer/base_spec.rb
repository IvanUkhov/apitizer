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
    it 'requires a block' do
      expect { subject_class.new }.to raise_error(
        Apitizer::Error, 'Block is required')
    end

    it 'draws a routing map' do
      scope_name = address
      subject = subject_class.new { scope(scope_name) { resources(:articles) } }
      stub_request(:get, 'articles')
      expect { subject.process(:index, :articles) }.not_to raise_error
    end

    it 'customizes the mapping between the REST actions and HTTP verbs' do
      scope_name = address
      subject = subject_class.new(dictionary: { update: :delete }) do
        scope(scope_name) { resources(:articles) }
      end
      stub = stub_request(:delete, 'articles/xxx')
      subject.process(:update, :articles, 'xxx')
      expect(stub).to have_been_requested
    end
  end

  describe '#process' do
    subject do
      scope_name = address
      subject_class.new { scope(scope_name) { resources(:articles) } }
    end

    restful_actions.each do |action|
      method = rest_http_dictionary[action]
      steps = [ :articles ]
      steps << 'xxx' if restful_member_actions.include?(action)

      it "is capable of #{ action } actions" do
        stub_request(method, steps.join('/'))
        expect { subject.process(action, *steps) }.not_to raise_error
      end

      it "is capable of #{ action } actions via alias" do
        stub_request(method, steps.join('/'))
        expect { subject.send(action, *steps) }.not_to raise_error
      end
    end
  end
end
