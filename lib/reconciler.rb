require 'sinatra'
require 'json'
require 'slack-notifier'

# Should be ->
# attr_accessor :icon_url

@icon_url = nil

def value_defined?(value)
  true if value && value.strip != '' && !value.match('OPTIONAL:')
end

def send_message(msg)
  return nil unless ENV['SLACK_URL']
  notifier = Slack::Notifier.new(ENV['SLACK_URL'])
  if value_defined?(ENV['SLACK_CHANNEL'])
    notifier.channel = ENV['SLACK_CHANNEL']
  end
  if value_defined?(ENV['SLACK_USERNAME'])
    notifier.username = ENV['SLACK_USERNAME']
  end
  notifier.ping msg, icon_url: @icon_url if notifier && msg
end

def parse_incoming(body)
  inc = JSON.parse(body)
  return false unless inc['action'].match('labeled')
  return inc.merge(event: inc.delete('pull_request')) if inc['pull_request']
  return inc.merge(event: inc.delete('issue')) if inc['issue']
  false
end

def message_for_labels(body)
  incoming = parse_incoming(body) if body != ''
  return unless incoming
  @icon_url = incoming['sender']['avatar_url']
  "@#{incoming['sender']['login']} **#{incoming['action']}** " \
    "[#{incoming[:event]['title']}](#{incoming[:event]['html_url']}) " \
    "*#{incoming['label']['name']}*"
end

post '/' do
  message = message_for_labels(request.body.read)
  send_message(message) if message
  status '200'
  message || 'No request body'
end
