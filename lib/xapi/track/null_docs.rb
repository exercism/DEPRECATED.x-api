module Xapi
  # NullDocs is used as documentation for non-existent track
  class NullDocs
    def content
      Hash[Docs::TOPICS.zip(Array.new(Docs::TOPICS.size, ""))]
    end
  end
end
