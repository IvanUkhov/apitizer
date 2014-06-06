require 'spec_helper'

RSpec.describe Apitizer::Connection::Dispatcher do
  extend ResourceHelper
  include ResourceHelper

  let(:address) { 'https://service.com/api/articles' }

  def create_request(method)
    double(method: method, address: address, parameters: {})
  end

  describe '#process' do
    { :json => '{}', :yaml => '---' }.each do |format, sample|
      context "when interacting in #{ format }" do
        let(:subject) { Apitizer::Connection::Dispatcher.new(format: format) }

        http_methods.each do |method|
          context "when performing #{ method } operations" do
            it 'uses propoer HTTP methods' do
              stub = stub_http_request(method, address).to_return(body: sample)
              response = subject.process(create_request(method))
              expect(stub).to have_been_requested
            end

            it 'sets proper headers' do
              stub = stub_http_request(method, address).to_return(body: sample).
                with(headers: { 'Accept' => mime_type_dictionary[format] })
              response = subject.process(create_request(method))
              expect(stub).to have_been_requested
            end
          end
        end
      end
    end
  end
end
