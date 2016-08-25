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

    def meta_dir
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
      repo_url('json') if File.exist?(path("%s.json" % slug))
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
      path('%s.yml' % slug)
    end

    def md
      path('%s.md' % slug)
    end

    def path(file_name)
      old_path = root_path(file_name)
      File.exists?(old_path) ? old_path : File.join(meta_dir, file_name)
    end

    def root_path(f)
      File.join(root, "metadata", f)
    end

    def metadata
      @metadata ||= YAML.load(File.read(yaml))
    end
  end
end
