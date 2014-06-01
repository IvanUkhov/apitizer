require 'spec_helper'

describe Apitizer::Result do
  let(:path) { double('Path') }
  let(:request) { double('Request', path: path) }
  let(:response) { double('Response', code: 200) }
  let(:content) { double('Content') }

  subject do
    Apitizer::Result.new(request: request, response: response, content: content)
  end

  it { should == content }
  its(:path) { should == path }
  its(:code) { should == 200 }
end
