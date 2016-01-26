require 'sinatra'
require 'dotenv'
require 'json'
require 'slack-notifier'
Dotenv.load

notifier = Slack::Notifier.new(ENV['SLACK_URL'])

def parse_incoming(body)
  inc = JSON.parse(body)
  return false unless inc['action'] == 'labeled'
  return inc.merge(action: inc.delete('pull_request')) if inc['pull_request']
  return inc.merge(action: inc.delete('issue')) if inc['issue']
  false
end

def message_for_labels(body)
  incoming = parse_incoming(body) if body != ''
  return nil unless incoming
  "@#{incoming[:action]['user']['login']} added label " \
  "*#{incoming['label']['name']}* to " \
  "[#{incoming[:action]['title']}](#{incoming[:action]['url']})"
end

post '/' do
  message = message_for_labels(request.body.read) if request.body
  notifier.ping message if message
  status '200'
  body message
end
