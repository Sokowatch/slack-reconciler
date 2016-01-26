require 'spec_helper'

describe 'app' do
  let(:target_label_response) do
    '@Zensaburou added label *Ready to merge* ' \
      'to [Cannot upload mp3s for certain universal messages]'\
      '(https://github.com/Reliefwatch/demo_repository/issues/393)'
  end

  describe 'value_defined?' do
    context 'empty' do
      it 'is false' do
        expect(value_defined?(' ')).to be_falsey
      end
    end
    context 'OPTIONAL: string, environmental prompt on Heroku' do
      it 'is false' do
        expect(value_defined?('OPTIONAL: defaults to ...')).to be_falsey
      end
    end
    context 'channel name' do
      it 'is true' do
        expect(value_defined?('stuff_Channel')).to be_truthy
      end
    end
  end

  describe 'parse_input' do
    it 'formats the message the way that we expect' do
      expect(message_for_labels(webhook_fixture)).to eq target_label_response
    end
  end

  describe 'posting' do
    context 'nothing posted' do
      it 'succeeds' do
        post '/'
        expect(last_response).to be_ok
        expect(last_response.body).to match(/no request body/i)
      end
    end
    context 'posting webhook body' do
      it 'succeeds' do
        post '/', webhook_fixture
        expect(last_response.body).to eq target_label_response
      end
    end
  end
end
