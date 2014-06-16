require 'spec_helper'

RSpec.describe Apitizer::Helper do
  extend ResourceHelper

  let(:subject_module) { Apitizer::Helper }

  describe '.member_action?' do
    restful_member_actions.each do |action|
      it "returns true for the #{ action } member action" do
        expect(subject_module.member_action?(action)).to be true
      end
    end

    restful_collection_actions.each do |action|
      it "returns false for the #{ action } collection action" do
        expect(subject_module.member_action?(action)).to be false
      end
    end

    it 'raises exceptions when encounters unknown actions' do
      expect { subject_module.member_action?(:rock) }.to \
        raise_error(subject_module::Error, /Unknown action/i)
    end
  end

  describe '.deep_merge' do
    it 'merges two hashes taking into account nested hashes' do
      one = { a: 1, b: { c: 2, d: 3 } }
      two = { a: 4, b: { c: 5, e: 6 } }
      expect(subject_module.deep_merge(one, two)).to \
        eq(a: 4, b: { c: 5, d: 3, e: 6 })
    end
  end

  describe '.build_query' do
    it 'handels ordinary parameters' do
      query = subject_module.build_query(
        title: 'Meaning of Life', author: 'Random Number Generator')
      expect(query).to \
        eq('title=Meaning+of+Life&author=Random+Number+Generator')
    end

    it 'handles parameters whose values are ordinary lists' do
      query = subject_module.build_query(keywords: [ 'hitchhiker', 'galaxy' ])
      expect(query).to eq('keywords[]=hitchhiker&keywords[]=galaxy')
    end

    it 'handles parameters whose values are lists with no elements' do
      query = subject_module.build_query(title: 'Pulp Fiction', keywords: [])
      expect(query).to eq('title=Pulp+Fiction')
    end

    it 'handles parameters whose values are object lists' do
      query = subject_module.build_query(
        genres: { 0 => { name: 'Comedy' }, 1 => { name: 'Fiction' } })
      expect(query).to \
        eq('genres[0][name]=Comedy&genres[1][name]=Fiction')
    end

    it 'converts integers to decimal strings' do
      query = subject_module.build_query(page: 42)
      expect(query).to eq('page=42')
    end

    it 'converts integers in object lists to decimal strings' do
      query = subject_module.build_query(
        primes: { 0 => { value: 2 }, 1 => { value: 3 } })
      expect(query).to \
        eq('primes[0][value]=2&primes[1][value]=3')
    end

    it 'converts the logical true to the string true' do
      query = subject_module.build_query(published: true)
      expect(query).to eq('published=true')
    end

    it 'converts the logical false to the string false' do
      query = subject_module.build_query(published: false)
      expect(query).to eq('published=false')
    end

    it 'returns a string encoded in UTF-8' do
      query = subject_module.build_query(alpha: 'omega')
      expect(query.encoding.to_s).to match(/^UTF-8$/i)
    end
  end
end
