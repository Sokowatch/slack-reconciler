require 'spec_helper'

describe 'app' do
  describe 'parse_input' do
    it 'formats the message the way that we expect' do
      expect(message_for_labels(webhook_fixture)).to eq(ENV['TARGET_MESSAGE'])
    end
  end

  describe 'posting' do
    context 'nothing posted' do
      it 'succeeds' do
        post '/'
        expect(last_response).to be_ok
      end
    end
    context 'posting webhook body' do
      it 'succeeds' do
        post '/', webhook_fixture
        expect(last_response).to be_ok
      end
    end
  end
end
