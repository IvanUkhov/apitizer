require 'spec_helper'

describe Apitizer::Processing::Parser do
  let(:parent_module) { Apitizer::Processing }
  let(:subject_class) { parent_module::Parser }

  it 'supports JSON' do
    subject = subject_class.build(:json)
    result = subject.process('{ "articles": [] }')
    expect(result).to eq("articles" => [])
  end

  it 'supports YAML' do
    subject = subject_class.build(:yaml)
    result = subject.process("---\narticles: []")
    expect(result).to eq("articles" => [])
  end

  it 'does not support XML' do
    expect { subject_class.build(:xml) }.to \
      raise_error(parent_module::Error, /Unknown format/i)
  end
end
