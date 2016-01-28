module ReconcilerParser
  class Base
    def initialize(body)
      @body = parse_body(body)
    end
  end
end
