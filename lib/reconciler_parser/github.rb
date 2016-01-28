module ReconcilerParser
  class Github < Base
    def parse_body(unparsed_body)
      inc = JSON.parse(unparsed_body)
      return inc.merge(event: inc.delete('pull_request')) if inc['pull_request']
      return inc.merge(event: inc.delete('issue')) if inc['issue']
      return inc if inc['pages']
      false
    rescue
      false
    end

    def message_for_labels
      "@#{@body['sender']['login']} _#{@body['action']}_ " \
        "[#{@body[:event]['title']}](#{@body[:event]['html_url']}) " \
        "*#{@body['label']['name']}*"
    end

    def pages(pages)
      pages.map do |page|
        "_#{page['action']}_ " \
          "the wiki page [#{page['title']}](#{page['html_url']})"
      end
    end

    def message_for_wiki
      "@#{@body['sender']['login']} " +
        pages(@body['pages']).to_sentence
    end

    def icon_url
      @body && @body['sender']['avatar_url']
    end

    def slack_channel
      '#general' if @body && event_type == 'wiki'
    end

    def event_type
      if @body['action'] && @body['action'].match('labeled')
        'labels'
      elsif @body['pages']
        'wiki'
      end
    end

    def message
      return nil unless @body
      send("message_for_#{event_type}") if event_type
    end
  end
end
