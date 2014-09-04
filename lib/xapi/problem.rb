module Xapi
  class Problem
    Name = Proc.new {|problem| [problem.language, problem.slug] }

    attr_reader :track_id, :slug, :state, :path

    def initialize(*args)
      @track_id, @slug, @state, @path = *args
      attributes = {}

      if args.last.is_a?(Hash)
        attributes = args.pop
      end

      attributes.each {|field, value|
        instance_variable_set(:"@#{field}", value)
      }
    end

    alias_method :language, :track_id

    def id
      [track_id, slug].join("/")
    end

    def name
      slug.split('-').map(&:capitalize).join(' ')
    end

    def fresh?
      state == 'fresh'
    end

    def completed?
      state == 'done'
    end

    def not_found?
      unknown_language? || unknown_problem?
    end

    def error_message
      if unknown_language?
        "We don't have problems in language '#{language}'"
      elsif unknown_problem?
        "We don't have problem '#{slug}' in '#{language}'"
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
      File.join(path, 'problems', language)
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
