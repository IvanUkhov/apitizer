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
  it { should be_a(content.class) }
  it { should be_kind_of(content.class) }
  it { should be_instance_of(content.class) }
  its(:path) { should == path }
  its(:code) { should == 200 }
end
