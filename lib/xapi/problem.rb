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
      repo_url('description', 'md')
    end

    def json_url
      json_file = path_to('canonical-data', 'json')
      repo_url('canonical-data', 'json') if File.exist?(json_file)
    end

    def yaml_url
      repo_url('metadata', 'yml')
    end

    %w(blurb source source_url).each do |name|
      define_method name do
        metadata[name].to_s.strip
      end
    end

    private

    def repo_url(target, ext)
      "https://github.com/exercism/x-common/blob/master/exercises/%s/%s.%s" %
        [slug, target, ext]
    end

    def yaml
      path_to('metadata', 'yml')
    end

    def md
      path_to('description', 'md')
    end

    def path(file_name)
      File.join(root, "metadata", file_name)
    end

    def metadata
      @metadata ||= YAML.load(File.read(yaml))
    end

    def path_to(target, extension)
      default_path = File.join(metadata_dir, "#{target}.#{extension}")
      deprecated_path = path("#{slug}.#{extension}")
      File.exist?(default_path) ? default_path : deprecated_path
    end
  end
end
