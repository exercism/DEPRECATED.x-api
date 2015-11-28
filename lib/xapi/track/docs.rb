require 'org-ruby'

module Xapi
  # Track-specific documentation
  class Docs
    TOPICS = %w(about installation tests learning resources)

    def initialize(path)
      @dir = File.join(path, 'docs')
    end

    def content
      Hash[TOPICS.zip(TOPICS.map { |topic| read(topic) })]
    end

    def exists?
      File.exist?(dir)
    end

    def image(image)
      Xapi::Image.new(image, dir)
    end

    private

    attr_reader :dir

    def read(topic)
      f = Dir.glob("%s/%s.*" % [dir, topic.upcase]).first
      case f
      when /\.md/
        File.read(f)
      when /\.org/
        Orgmode::Parser.new(File.read(f)).to_markdown
      else
        ""
      end
    end
  end
end
