require 'slack-notifier'

class ReconcilerNotifier
  def initialize(icon_url: nil, channel: nil)
    @icon_url = icon_url
    @channel = channel
  end

  def defined_env(value)
    (value && value.strip != '' && !value.match('OPTIONAL:')) ? value : nil
  end

  def defined_channel(value)
    @channel ? @channel : defined_env(value)
  end

  def notifier
    @notifier ||= Slack::Notifier.new(
      ENV['SLACK_URL'],
      channel: defined_channel(ENV['SLACK_CHANNEL']),
      username: defined_env(ENV['SLACK_USERNAME']))
  end

  def send_message(msg)
    return nil unless ENV['SLACK_URL'] && msg
    notifier.ping msg, icon_url: @icon_url if notifier
  end
end
