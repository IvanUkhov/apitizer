require 'spec_helper'

describe Apitizer::Connection::Adaptor do
  let(:parent_module) { Apitizer::Connection }
  let(:address) { 'https://service.com/api/v1/json/articles' }

  [ 'Standard' ].each do |adaptor|
    subject { parent_module::Adaptor.const_get(adaptor).new }

    describe "#{ adaptor }.process" do
      it 'returns the code, headers, and body of the response' do
        stub_http_request(:get, address).to_return(
          code: '200', body: 'Hej!', headers: { 'a' => 'b' } )
        response = subject.process(:get, address)
        expect(response).to eq([ '200', { 'a' => [ 'b' ] }, 'Hej!' ])
      end

      it 'raises exceptions when encounters unknown methods' do
        expect { subject.process(:smile, address) }.to \
          raise_error(parent_module::Error, /Invalid method/i)
      end
    end
  end
end
