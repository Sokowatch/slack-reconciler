require 'slack-notifier'

class ReconcilerNotifier
  def initialize(icon_url: nil)
    @icon_url = icon_url
  end

  def defined_env(value)
    (value && value.strip != '' && !value.match('OPTIONAL:')) ? value : nil
  end

  def notifier
    @notifier ||= Slack::Notifier.new(
      ENV['SLACK_URL'],
      channel: defined_env(ENV['SLACK_CHANNEL']),
      username: defined_env(ENV['SLACK_USERNAME']))
  end

  def send_message(msg)
    return nil unless ENV['SLACK_URL'] && msg
    notifier.ping msg, icon_url: @icon_url if notifier
  end
end
