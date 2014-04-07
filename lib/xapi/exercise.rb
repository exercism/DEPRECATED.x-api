module Xapi
  class Exercise
    Name = Proc.new {|exercise| [exercise.language, exercise.slug] }

    attr_reader :language, :slug, :state, :path

    def initialize(language, slug, state='fresh', path='.')
      @language = language
      @slug = slug
      @path = path
      @state = state
      @fresh = false
    end

    def fresh?
      state == 'fresh'
    end

    def completed?
      state == 'done'
    end

    def not_found?
      unknown_language? || unknown_exercise?
    end

    def error_message
      if unknown_language?
        "We don't have exercises in language '#{language}'"
      elsif unknown_exercise?
        "We don't have exercise '#{slug}' in '#{language}'"
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
      File.join(path, 'exercises', language)
    end

    def dir
      File.join(language_dir, slug)
    end

    def unknown_language?
      !File.exist?(language_dir)
    end

    def unknown_exercise?
      !File.exist?(dir)
    end
  end
end
