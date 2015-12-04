module Xapi
  # NullProblem is a non-existent problem
  class NullProblem
    attr_reader :track_id, :slug, :path, :language

    def initialize(attributes)
      attributes.each {|field, value|
        instance_variable_set(:"@#{field}", value)
      }
    end

    alias_method :name, :slug

    def exists?
      false
    end

    def blurb
      ''
    end

    def readme
      ''
    end

    def test_files
      {}
    end

    def not_found?
      !exists?
    end

    def validate
      false
    end

    def error_message
      if unknown_language?
        "We don't have problems in language '#{track_id}'"
      elsif unknown_problem?
        "We don't have problem '#{slug}' in '#{track_id}'"
      end
    end
    alias_method :error, :error_message

    private

    def language_dir
      File.join(path, 'tracks', track_id)
    end

    def unknown_language?
      !File.exist?(language_dir)
    end

    def unknown_problem?
      !exists?
    end
  end
end
