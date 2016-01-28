module ReconcilerParser
  class Github < Base
    def parse_incoming
      inc = JSON.parse(@body)
      return inc.merge(event: inc.delete('pull_request')) if inc['pull_request']
      return inc.merge(event: inc.delete('issue')) if inc['issue']
      return inc if inc['pages']
      false
    end

    def message_for_labels(parsed_body)
      "@#{parsed_body['sender']['login']} _#{parsed_body['action']}_ " \
        "[#{parsed_body[:event]['title']}](#{parsed_body[:event]['html_url']}) " \
        "*#{parsed_body['label']['name']}*"
    end

    def pages(pages)
      pages.map do |page|
        "_#{page['action']}_ " \
          "the wiki page [#{page['title']}](#{page['html_url']})"
      end
    end

    def message_for_wiki(parsed_body)
      "@#{parsed_body['sender']['login']} " +
        pages(parsed_body['pages']).to_sentence
    end

    def message
      parsed_body = parse_incoming if @body.strip != ''
      return nil unless parsed_body
      @icon_url = parsed_body['sender']['avatar_url']
      if parsed_body['action'] && parsed_body['action'].match('labeled')
        message_for_labels(parsed_body)
      elsif parsed_body['pages']
        message_for_wiki(parsed_body)
      end
    end
  end
end
