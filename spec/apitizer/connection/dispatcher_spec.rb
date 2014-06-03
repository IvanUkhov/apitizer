require 'spec_helper'

describe Apitizer::Connection::Dispatcher do
  extend ResourceHelper
  include ResourceHelper

  let(:address) { 'https://service.com/api/articles' }

  def create_request(action)
    double(action: action, address: address, parameters: {})
  end

  describe '#process' do
    { :json => '{}', :yaml => '---' }.each do |format, sample|
      context "when interacting via #{ format }" do
        let(:subject) do
          Apitizer::Connection::Dispatcher.new(
            format: format, dictionary: rest_http_dictionary)
        end

        restful_actions.each do |action|
          method = rest_http_dictionary[action]

          context "when performing #{ action } actions" do
            it "uses the #{ method } HTTP verb" do
              stub = stub_http_request(method, address).to_return(body: sample)
              response = subject.process(create_request(action))
              expect(stub).to have_been_requested
            end

            it 'sets proper headers' do
              stub = stub_http_request(method, address).to_return(body: sample).
                with(headers: { 'Accept' => mime_type_dictionary[format] })
              response = subject.process(create_request(action))
              expect(stub).to have_been_requested
            end
          end
        end
      end
    end
  end
end
