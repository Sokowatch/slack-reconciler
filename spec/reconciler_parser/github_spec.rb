require 'spec_helper'

describe ReconcilerParser::Github do
  let(:github_labeled_fixture) { File.read('spec/fixtures/github_labeled_webhook.json') }
  let(:github_unlabeled_fixture) { File.read('spec/fixtures/github_unlabeled_webhook.json') }
  let(:github_wiki_fixture) { File.read('spec/fixtures/github_wiki_webhook.json') }

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

  let(:target_wiki_response) do
    '@sethherr _edited_ the wiki page [Style guide]' \
      '(https://github.com/Reliefwatch/wiki/wiki/Style-guide) and ' \
      '_edited_ the wiki page [Another page]' \
      '(https://github.com/Reliefwatch/wiki/wiki/another-page)'
  end

  describe 'message' do
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
    context 'wiki' do
      it 'formats the message the way that we expect' do
        parser = ReconcilerParser::Github.new(github_wiki_fixture)
        expect(parser.message).to eq target_wiki_response
      end
    end
  end

  context 'wiki fixture' do
    let(:parser) { ReconcilerParser::Github.new(github_wiki_fixture) }
    it 'assigns the icon url' do
      expect(parser.icon_url).to eq 'https://avatars.githubusercontent.com/u/1235441?v=3'
    end

    it 'sends wiki updates to the general channel' do
      expect(parser.slack_channel).to eq '#general'
    end
  end

  context 'labeled_fixture' do
    let(:parser) { ReconcilerParser::Github.new(github_labeled_fixture) }
    it 'assigns the icon url' do
      expect(parser.icon_url).to eq 'https://avatars.githubusercontent.com/u/1235441?v=3'
    end

    it 'returns nil for slack_channel' do
      expect(parser.slack_channel).to eq nil
    end
  end
end
