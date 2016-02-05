module ReconcilerParser
  class Github < Base
    def parse_body(unparsed_body)
      inc = JSON.parse(unparsed_body)
      return inc if inc['action'] == 'closed'
      return inc.merge(event: inc.delete('pull_request')) if inc['pull_request']
      return inc.merge(event: inc.delete('issue')) if inc['issue']
      return inc if inc['pages']
      false
    rescue
      puts 'Invalid JSON'
      false
    end

    def message
      return nil unless @body
      send("message_for_#{event_type}") if event_type
    end

    def message_for_labels
      "@#{@body['sender']['login']} _#{@body['action']}_ " \
        "[#{@body[:event]['title']}](#{@body[:event]['html_url']}) " \
        "*#{@body['label']['name']}*"
    end

    def message_for_wiki
      "@#{@body['sender']['login']} " +
        pages(@body['pages']).to_sentence
    end

    def message_for_milestone
      "#{@body['pull_request']['milestone']['title']} Milestone _completed for_ " \
        "#{@body['repository']['name']}"
    end

    def pages(pages)
      pages.map do |page|
        "_#{page['action']}_ " \
          "the wiki page [#{page['title']}](#{page['html_url']})"
      end
    end

    def icon_url
      @body && @body['sender']['avatar_url']
    end

    def slack_channel
      '#general' if @body && wiki_or_milestone_event?
    end

    def wiki_or_milestone_event?
      return false unless @body
      event_type == 'wiki' || event_type == 'milestone'
    end

    def event_type
      if label_added?
        'labels'
      elsif pull_request_closed? && milestone_complete?
        'milestone'
      elsif @body['pages']
        'wiki'
      end
    end

    def label_added?
      @body['action'] && @body['action'].match('labeled')
    end

    def pull_request_closed?
      @body['action'] && @body['action'].match('closed')
    end

    def milestone_complete?
      return unless @body['pull_request']
      return unless @body['pull_request']['milestone']
      return unless @body['pull_request']['milestone']['open_issues']

      open_issue_count = @body['pull_request']['milestone']['open_issues']
      open_issue_count == 0
    end
  end
end
