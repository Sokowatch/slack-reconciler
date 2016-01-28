module ReconcilerParser
  class Github < Base
    def parse_incoming
      inc = JSON.parse(@body)
      return inc.merge(event: inc.delete('pull_request')) if inc['pull_request']
      return inc.merge(event: inc.delete('issue')) if inc['issue']
      false
    end

    def message_for_labels(parsed_body)
      icon_url = parsed_body['sender']['avatar_url']
      "@#{parsed_body['sender']['login']} _#{parsed_body['action']}_ " \
        "[#{parsed_body[:event]['title']}](#{parsed_body[:event]['html_url']}) " \
        "*#{parsed_body['label']['name']}*"
    end

    def message
      parsed_body = parse_incoming if @body.strip != ''
      return nil unless parsed_body
      if parsed_body['action'].match('labeled')
        message_for_labels(parsed_body)
      end
    end
  end
end
