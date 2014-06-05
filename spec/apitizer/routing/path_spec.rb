require 'spec_helper'

RSpec.describe Apitizer::Routing::Path do
  let(:subject_class) { Apitizer::Routing::Path }

  describe '#advance' do
    it 'builds up addresses' do
      subject.advance('articles', node: double)
      subject.advance('xxx', node: double)
      expect(subject.address).to eq('articles/xxx')
    end
  end

  describe '#clone' do
    it 'properly does its job' do
      subject.advance('articles', node: double)
      another = subject.clone
      another.advance('xxx', node: double)
      expect(subject.address).to eq('articles')
    end
  end
end
