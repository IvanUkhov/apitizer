require 'spec_helper'

RSpec.describe Apitizer::Base do
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
      prefix = address
      subject = subject_class.new do
        address(prefix)
        resources(:articles)
      end
      stub_request(:get, 'articles')
      expect { subject.process(:index, :articles) }.not_to raise_error
    end

    it 'customizes the mapping between the REST actions and HTTP verbs' do
      prefix = address
      subject = subject_class.new(dictionary: { update: :delete }) do
        address(prefix)
        resources(:articles)
      end
      stub = stub_request(:delete, 'articles/xxx')
      subject.process(:update, :articles, 'xxx')
      expect(stub).to have_been_requested
    end
  end

  describe '#define' do
    it 'is another way of drawing a routing map' do
      prefix = address
      subject = subject_class.new
      subject.define do
        address(prefix)
        resources(:articles)
      end
      stub_request(:get, 'articles')
      expect { subject.process(:index, :articles) }.not_to raise_error
    end
  end

  describe '#process' do
    subject do
      prefix = address
      subject_class.new do
        address(prefix)
        resources(:articles)
      end
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
