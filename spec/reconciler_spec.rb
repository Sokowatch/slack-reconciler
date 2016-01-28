require 'spec_helper'

describe 'app' do
  let(:github_labeled_fixture) { File.read('spec/fixtures/github_labeled_webhook.json') }
  let(:github_unlabeled_fixture) { File.read('spec/fixtures/github_unlabeled_webhook.json') }

  describe '/github' do
    context 'nothing posted' do
      it 'succeeds' do
        post '/github'
        expect(last_response).to be_ok
        expect(last_response.body).to match(/no request body/i)
      end
    end
    describe 'label' do
      context 'without notifier' do
        it 'succeeds' do
          post '/github', github_labeled_fixture
          expect(last_response.body).to match '_labeled_'
        end
      end
      context 'with notifier' do
        context 'empty request' do
          it 'does not send empty requests' do
            expect_any_instance_of(Slack::Notifier).to_not receive(:ping)
            post '/github'
            expect(last_response).to be_ok
            expect(last_response.body).to match(/no request body/i)
          end
        end
      end
    end
  end
end
