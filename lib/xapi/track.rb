require 'json'
require 'pathname'
require 'org-ruby'
require_relative 'file_bundle'
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
      @root = Pathname.new(root)
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

    def checklist_issue
      config.fetch("checklist_issue", 1)
    end

    def gitter
      config["gitter"]
    end

    def icon_url
      if img("img/icon.png").exists?
        "#{Xapi::ROOT_URL}/v3/tracks/#{id}/img/icon.png"
      end
    end

    %w(language repository).each do |name|
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
      Hash[TOPICS.zip(TOPICS.map { |topic| document_contents(topic) })]
    end

    def img(file_path)
      Image.new(File.join(dir, file_path))
    end

    def slugs
      problems + foregone + deprecated
    end

    def doc_format
      default_format = 'md'
      path = File.join(dir, "docs", "*.*")
      most_popular_format(path) || default_format
    end

    def global_zip
      global_dir = dir.join("global")
      @zip ||= FileBundle.create_zip(global_dir, FileBundle.paths(global_dir))
    end

    private

    def most_popular_format(path)
      formats = Dir.glob(path).map do |filename|
        File.extname(filename).sub(/^\./, '')
      end
      formats.max_by { |format| formats.count(format) }
    end

    def dir
      root.join("tracks", id)
    end

    def config
      @config ||= JSON.parse(File.read(config_filename))
    end

    def config_filename
      File.join(dir, "config.json")
    end

    def document_contents(topic)
      filename = document_fiename(topic)
      case filename
      when /\.md$/
        File.read(filename)
      when /\.org$/
        Orgmode::Parser.new(File.read(filename)).to_markdown
      else
        ''
      end
    end

    def document_fiename(topic)
      path = File.join(dir, "docs", topic.upcase)
      Dir.glob("%s.*" % path).sort.first
    end
  end
end
