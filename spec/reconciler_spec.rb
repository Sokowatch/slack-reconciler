require 'spec_helper'

describe 'app' do
  describe 'parse_input' do
    it 'formats the message the way that we expect' do
      expect(message_for_labels(webhook_fixture)).to eq(ENV['TARGET_MESSAGE'])
    end
  end
end
