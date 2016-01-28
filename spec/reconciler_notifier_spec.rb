require 'spec_helper'

describe ReconcilerNotifier do
  describe 'env_defined?' do
    let(:notifier) { ReconcilerNotifier.new }
    context 'empty' do
      it 'is false' do
        expect(notifier.defined_env(' ')).to be_nil
      end
    end
    context 'OPTIONAL: string, environmental prompt on Heroku' do
      it 'is false' do
        expect(notifier.defined_env('OPTIONAL: defaults to ...')).to be_falsey
      end
    end
    context 'channel name' do
      it 'is true' do
        expect(notifier.defined_env('stuff_Channel')).to be_truthy
      end
    end
  end
end
