require 'spec_helper'

describe Apitizer::Connection::Adaptor do
  let(:parent_module) { Apitizer::Connection }
  let(:address) { 'https://service.com/api/articles' }

  shared_examples 'a proper postman' do |method:|
    it 'takes into account headers' do
      headers = { 'Secret-Token' => 'arbitrary' }
      stub = stub_http_request(method, address).with(headers: headers)
      subject.process(method, address, {}, headers)
      expect(stub).to have_been_requested
    end
  end

  shared_examples '#call of a Rack app' do |method:|
    let(:code) { 200 }
    let(:headers) { { 'a' => [ 'b' ] } }
    let(:body) { 'Hej!' }

    before(:each) do
      stub_http_request(method, address).to_return(
        code: code, headers: headers, body: body)
    end

    let(:response) { subject.process(method, address) }

    it 'returns an array with three elements' do
      expect(response.length).to eq(3)
    end

    it 'returns the code as the first element' do
      expect(response[0]).to eq(code)
    end

    it 'returns the code as an integer' do
      expect(response[0]).to be_kind_of(Integer)
    end

    it 'returns the headers as the second element' do
      expect(response[1]).to eq(headers)
    end

    it 'returns the headers as a hash' do
      expect(response[1]).to be_kind_of(Hash)
    end

    it 'returns the body as the third element' do
      expect(response[2]).to eq([ body ])
    end

    it 'returns the body as an object responding to #each' do
      expect(response[2]).to respond_to(:each)
    end
  end

  describe '::Standard' do
    subject { parent_module::Adaptor::Standard.new }

    describe '#process' do
      [ :get ].each do |method|
        context "when sending #{ method } requests" do
          it_behaves_like '#call of a Rack app', method: method
          it_behaves_like 'a proper postman', method: method

          it 'encodes parameters into the URI' do
            stub = stub_http_request(method, address).with(query: { life: 42 })
            subject.process(method, address, life: 42)
            expect(stub).to have_been_requested
          end
        end
      end

      [ :post, :put, :patch, :delete ].each do |method|
        context "when sending #{ method } requests" do
          it_behaves_like '#call of a Rack app', method: method
          it_behaves_like 'a proper postman', method: method

          it 'encodes parameters into the body' do
            stub = stub_http_request(method, address).with(body: 'life=42')
            response = subject.process(method, address, life: 42)
            expect(stub).to have_been_requested
          end
        end
      end

      it 'raises exceptions for unknown methods' do
        expect { subject.process(:smile, address) }.to \
          raise_error(parent_module::Error, /Invalid method/i)
      end
    end
  end
end
