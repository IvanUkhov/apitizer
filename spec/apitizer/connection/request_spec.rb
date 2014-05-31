require 'spec_helper'

describe Apitizer::Connection::Request do
  subject { Apitizer::Connection::Request.new(action: :show) }

  describe '#address' do
    it 'assembles the address' do
      [ :articles, 'xxx', :sections, 'yyy' ].each { |chunk| subject << chunk }
      expect(subject.address).to eq('articles/xxx/sections/yyy')
    end
  end
end
