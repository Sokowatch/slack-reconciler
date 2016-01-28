require 'spec_helper'

describe ReconcilerParser::Github do
  let(:github_labeled_fixture) { File.read('spec/fixtures/github_labeled_webhook.json') }
  let(:github_unlabeled_fixture) { File.read('spec/fixtures/github_unlabeled_webhook.json') }

  let(:target_label_response) do
    '@sethherr _labeled_ [Cannot upload mp3s for certain universal messages]' \
      '(https://github.com/Reliefwatch/demo_repository/issues/393) ' \
      '*Ready to merge*'
  end

  let(:target_unlabel_response) do
    '@sethherr _unlabeled_ [Integration testing file]' \
      '(https://github.com/Reliefwatch/demo_repository/issues/143) ' \
      '*Upcoming*'
  end

  describe 'message_for_labels' do
    context 'labeled' do
      it 'formats the message the way that we expect' do
        parser = ReconcilerParser::Github.new(github_labeled_fixture)
        expect(parser.message).to eq target_label_response
      end
    end
    context 'unlabeled' do
      it 'formats the message the way that we expect' do
        parser = ReconcilerParser::Github.new(github_unlabeled_fixture)
        expect(parser.message).to eq target_unlabel_response
      end
    end
  end
end
