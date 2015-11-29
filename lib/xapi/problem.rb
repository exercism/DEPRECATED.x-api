module Xapi
  # Problem represents a README and related code in a given language track.
  class Problem
    Name = proc { |problem| [problem.language, problem.slug] }

    attr_reader :track_id, :slug, :path, :language

    def initialize(attributes)
      attributes.each {|field, value|
        instance_variable_set(:"@#{field}", value)
      }
    end

    def id
      [track_id, slug].join("/")
    end

    def exists?
      File.exist?(dir)
    end

    def name
      slug.split('-').map(&:capitalize).join(' ')
    end

    def not_found?
      !exists?
    end

    def validate
      !unknown_language? && !unknown_problem?
    end

    def error_message
      if unknown_language?
        "We don't have problems in language '#{track_id}'"
      elsif unknown_problem?
        "We don't have problem '#{slug}' in '#{track_id}'"
      end
    end
    alias_method :error, :error_message

    def files
      code.merge('README.md' => readme)
    end

    def code
      Code.new(dir).files
    end

    def blurb
      meta.blurb
    end

    def readme
      meta.text
    end

    def test_files
      Tests.new(path: language_dir, files: files).test_files
    end

    private

    def setup
      File.read(File.join(language_dir, 'SETUP.md')) rescue nil
    end

    def language_dir
      File.join(path, 'tracks', track_id)
    end

    def dir
      File.join(language_dir, slug)
    end

    def unknown_language?
      !File.exist?(language_dir)
    end

    def unknown_problem?
      !exists?
    end

    def meta
      @meta ||= Readme.new(slug, path, setup)
    end
  end
end
