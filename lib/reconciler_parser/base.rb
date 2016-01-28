module ReconcilerParser
  class Base
    attr_accessor :icon_url

    def initialize(body)
      @body = body
    end
  end
end
