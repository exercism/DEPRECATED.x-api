require 'json'
require 'org-ruby'

module Xapi
  # Track is a collection of exercises in a given language.
  class Track
    TOPICS = %w(about installation tests learning resources)

    Image = Struct.new(:path) do
      def exists?
        File.exist?(path)
      end

      def type
        File.extname(path).sub('.', '').to_sym
      end
    end

    attr_reader :id, :root
    def initialize(id, root)
      @id = id
      @root = root
    end

    def exists?
      File.exist?(dir)
    end

    def active?
      !!config["active"]
    end

    def implementations
      @implementations ||= Implementations.new(id, repository, problems, root)
    end

    %w(language repository checklist_issue).each do |name|
      define_method name do
        config[name].to_s.strip
      end
    end

    %w(problems deprecated foregone).each do |name|
      define_method name do
        config[name] || []
      end
    end

    def test_pattern
      if config.key?('test_pattern')
        Regexp.new(config['test_pattern'])
      else
        /test/i
      end
    end

    def docs
      Hash[TOPICS.zip(TOPICS.map { |topic| doc(topic) })]
    end

    def img(f)
      Image.new(File.join(dir, "docs", "img", f))
    end

    def slugs
      problems + foregone + deprecated
    end

    private

    def dir
      File.join(root, "tracks", id)
    end

    def config
      @config ||= JSON.parse(File.read(File.join(dir, "config.json")))
    end

    def doc(topic)
      path = File.join(dir, "docs", topic.upcase)
      f = Dir.glob("%s.*" % path).first
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
