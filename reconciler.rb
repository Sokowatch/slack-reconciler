require 'sinatra'
require 'json'
require 'slack-notifier'

def value_defined?(value)
  true if value && value.strip != '' && !value.match('OPTIONAL:')
end

notifier = false
if ENV['SLACK_URL']
  notifier = Slack::Notifier.new(ENV['SLACK_URL'])
  if value_defined?(ENV['SLACK_CHANNEL'])
    notifier.channel = ENV['SLACK_CHANNEL']
  end
  if value_defined?(ENV['SLACK_USERNAME'])
    notifier.username = ENV['SLACK_USERNAME']
  end
end

def parse_incoming(body)
  inc = JSON.parse(body)
  return false unless inc['action'] == 'labeled'
  return inc.merge(action: inc.delete('pull_request')) if inc['pull_request']
  return inc.merge(action: inc.delete('issue')) if inc['issue']
  false
end

def message_for_labels(body)
  incoming = parse_incoming(body) if body != ''
  return 'No request body' unless incoming
  "@#{incoming[:action]['user']['login']} added label " \
    "*#{incoming['label']['name']}* to " \
    "[#{incoming[:action]['title']}](#{incoming[:action]['html_url']})"
end

post '/' do
  message = message_for_labels(request.body.read)
  notifier.ping message if notifier
  status '200'
  message
end
