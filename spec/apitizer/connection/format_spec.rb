require 'spec_helper'

RSpec.describe Apitizer::Connection::Format do
  let(:subject_class) { Apitizer::Connection::Format }

  { :json => '{ "articles": [] }',
    :yaml => "---\narticles: []" }.each do |format, sample|

    it "supports #{ format }" do
      subject = subject_class.build(format)
      result = subject.process(sample)
      expect(result).to eq('articles' => [])
    end
  end
end
