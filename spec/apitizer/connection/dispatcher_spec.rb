require 'spec_helper'

describe Apitizer::Connection::Dispatcher do
  extend ResourceHelper

  let(:headers) { { 'Secret-Token' => 'arbitrary' } }
  let(:address) { 'https://service.com/api/v1/json/articles' }
  let(:subject) { Apitizer::Connection::Dispatcher.new(headers: headers) }

  describe '#send' do
    restful_actions.each do |action|
      method = rest_http_dictionary[action]

      context "when sending #{ action } Requests" do
        it 'sets the token header' do
          stub = stub_http_request(method, address)
          response = subject.send(action, double(address: address))
          expect(stub).to \
            have_requested(method, address).with(headers: headers)
        end

        it 'returns Responses' do
          stub_http_request(method, address).
            to_return(code: '200', body: 'Hej!')
          response = subject.send(action, double(address: address))
          expect([ response.code, response.body ]).to eq([ 200, 'Hej!' ])
        end
      end
    end
  end
end
