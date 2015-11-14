module Xapi
  # Track-specific documentation
  class Docs
    TOPICS = %w(hello about workflow resources installation tools)

    def initialize(path)
      @dir = File.join(path, 'docs')
    end

    def content
      Hash[TOPICS.zip(TOPICS.map { |topic| read(topic) })]
    end

    private

    attr_reader :dir

    def read(topic)
      File.read("#{dir}/#{topic.upcase}.md") rescue ""
    end
  end
end
