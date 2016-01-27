require 'spec_helper'

describe 'app' do
  let(:github_labeled_fixture) { File.read('spec/fixtures/github_labeled_webhook.json') }
  let(:github_unlabeled_fixture) { File.read('spec/fixtures/github_unlabeled_webhook.json') }

  let(:target_label_response) do
    '@sethherr **labeled** [Cannot upload mp3s for certain universal messages]' \
      '(https://github.com/Reliefwatch/demo_repository/issues/393) ' \
      '*Ready to merge*'
  end

  let(:target_unlabel_response) do
    '@sethherr **unlabeled** [Integration testing file]' \
      '(https://github.com/Reliefwatch/demo_repository/issues/143) ' \
      '*Upcoming*'
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
    context 'labeled' do
      it 'formats the message the way that we expect' do
        expect(message_for_labels(github_labeled_fixture)).to eq target_label_response
      end
    end
    context 'unlabeled' do
      it 'formats the message the way that we expect' do
        expect(message_for_labels(github_unlabeled_fixture)).to eq target_unlabel_response
      end
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
        post '/', github_labeled_fixture
        expect(last_response.body).to eq target_label_response
      end
    end
    context 'with notifier' do
      context 'empty request' do
        it 'does not send empty requests' do
          expect_any_instance_of(Slack::Notifier).to_not receive(:ping)
          post '/'
          expect(last_response).to be_ok
          expect(last_response.body).to match(/no request body/i)
        end
      end
    end
  end
end
