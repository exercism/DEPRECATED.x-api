module Xapi
  class Exercise
    attr_reader :language, :slug, :path

    def initialize(language, slug, path='.')
      @language = language
      @slug = slug
      @path = path
    end

    def files
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
  end
end
