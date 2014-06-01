require 'spec_helper'

describe Apitizer::Routing::Mapper do
  extend ResourceHelper

  let(:subject_class) { Apitizer::Routing::Mapper }

  def create_path
    double(:<< => nil, :advance => nil)
  end

  def expect_steps(steps, path = create_path)
    Array(steps).each do |step|
      expect(path).to receive(:<<).once.ordered.with(step)
    end
    path
  end

  def expect_trace(mapper, steps, scope = [])
    mapper.trace(steps, expect_steps(scope + steps))
  end

  describe '#define' do
    it 'declares plain resources' do
      subject.define { resources(:articles) }
      expect_trace(subject, [ :articles ])
    end

    it 'declares nested resources' do
      subject.define { resources(:articles) { resources(:sections) } }
      expect_trace(subject, [ :articles, 'xxx', :sections, 'yyy' ])
    end

    it 'declares scoped resources' do
      subject.define do
        scope 'https://service.com/api' do
          scope [ 'v1', :json ] do
            resources(:articles) { resources(:sections) }
          end
        end
      end
      expect_trace(subject, [ :articles, 'xxx', :sections, 'yyy' ],
       [ 'https://service.com/api', 'v1', :json ])
    end

    restful_member_actions.each do |action|
      it "declares custom #{ action } operations on members" do
        subject.define do
          resources(:articles) { send(action, :shred, on: :member) }
        end
        expect_trace(subject, [ :articles, 'xxx', :shred ])
      end

      it 'declares custom operations with variable names' do
        subject.define do
          resources(:articles) { send(action, ':paragraph', on: :member) }
        end
        expect_trace(subject, [ :articles, 'xxx', 'zzz' ])
      end
    end

    it 'does not support reopening of resource declarations' do
      subject.define do
        resources(:articles)
        resources(:articles) { resources(:sections) }
      end
      expect { subject.trace([ :articles, 'xxx', :sections, 'yyy' ]) }.to \
        raise_error(Apitizer::Routing::Error, /Not found/i)
    end
  end
end
