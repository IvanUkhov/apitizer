require 'spec_helper'

describe Apitizer::Connection::Dispatcher do
  extend ResourceHelper
  include ResourceHelper

  let(:address) { 'https://service.com/api/articles' }
  let(:subject) do
    Apitizer::Connection::Dispatcher.new(
      dictionary: rest_http_dictionary)
  end

  def create_request(action, address)
    double(action: action, address: address, parameters: {})
  end

  describe '#process' do
    restful_actions.each do |action|
      method = rest_http_dictionary[action]

      context "when sending #{ action } Requests" do
        it 'returns proper Responses' do
          stub_http_request(method, address).
            to_return(code: '200', body: 'Hej!')
          response = subject.process(create_request(action, address))
          expect([ response.code, response.body ]).to eq([ 200, 'Hej!' ])
        end
      end
    end
  end
end
