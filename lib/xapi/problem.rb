module Xapi
  class Problem
    Name = Proc.new {|problem| [problem.language, problem.slug] }

    attr_reader :track_id, :slug, :path, :language

    def initialize(attributes)
      attributes.each {|field, value|
        instance_variable_set(:"@#{field}", value)
      }
    end

    def id
      [track_id, slug].join("/")
    end

    def name
      slug.split('-').map(&:capitalize).join(' ')
    end

    def not_found?
      unknown_language? || unknown_problem?
    end

    def error_message
      if unknown_language?
        "We don't have problems in language '#{track_id}'"
      elsif unknown_problem?
        "We don't have problem '#{slug}' in '#{track_id}'"
      end
    end

    def files
      code.merge('README.md' => readme)
    end

    def code
      Code.new(dir).files
    end

    def readme
      Readme.new(slug, path, setup).text
    end

    private

    def setup
      File.read(File.join(language_dir, 'SETUP.md')) rescue nil
    end

    def language_dir
      File.join(path, 'problems', track_id)
    end

    def dir
      File.join(language_dir, slug)
    end

    def unknown_language?
      !File.exist?(language_dir)
    end

    def unknown_problem?
      !File.exist?(dir)
    end
  end
end
