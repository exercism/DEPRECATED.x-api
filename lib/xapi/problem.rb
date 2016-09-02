require 'yaml'
module Xapi
  # Problem is a language-independent definition of an exercise.
  class Problem
    attr_reader :slug, :root
    def initialize(slug, root)
      @slug = slug
      @root = root
    end

    def exists?
      File.exist?(md) && File.exist?(yaml)
    end

    def metadata_dir
      File.join(root, "metadata", "exercises", slug)
    end

    def name
      @name ||= slug.split('-').map(&:capitalize).join(' ')
    end

    def description
      @description ||= File.read(md)
    end

    def source_markdown
      body = source.empty? ? "" : "%s" % source
      url = source_url.empty? ? "" : "[%s](%s)" % [source_url, source_url]
      if url.empty? && body.empty?
        ""
      else
        "## Source\n\n" + [body, url].reject(&:empty?).join(" ")
      end
    end

    def md_url
      repo_url('md')
    end

    def json_url
      json_file_path = File.join(metadata_dir, "canonical-data.json")
      repo_url('json') if File.exist?(json_file_path) ||
                          File.exist?(path("%s.json" % slug))
    end

    def yaml_url
      repo_url('yml')
    end

    %w(blurb source source_url).each do |name|
      define_method name do
        metadata[name].to_s.strip
      end
    end

    private

    def repo_url(ext)
      "https://github.com/exercism/x-common/blob/master/%s.%s" % [slug, ext]
    end

    def yaml
      find_file('metadata', 'yml')
    end

    def md
      find_file('description', 'md')
    end

    def path(file_name)
      File.join(root, "metadata", file_name)
    end

    def metadata
      @metadata ||= YAML.load(File.read(yaml))
    end

    def find_file(default_basename, suffix)
      default_file_name = "#{default_basename}.#{suffix}"
      default_path = File.join(metadata_dir, default_file_name)
      deprecated_path = path("#{slug}.#{suffix}")
      File.exist?(default_path) ? default_path : deprecated_path
    end
  end
end
