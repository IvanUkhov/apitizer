require 'spec_helper'

RSpec.describe Apitizer::Result do
  let(:path) { double('Path') }
  let(:request) { double('Request', path: path) }
  let(:content) { double('Content') }
  let(:response) { double('Response', code: 200, content: content) }

  subject { Apitizer::Result.new(request: request, response: response) }

  it { should == content }
  it { should be_a(content.class) }
  it { should be_kind_of(content.class) }
  it { should be_instance_of(content.class) }
  it { expect(subject.path).to eq(path) }
  it { expect(subject.code).to eq(200) }
end
