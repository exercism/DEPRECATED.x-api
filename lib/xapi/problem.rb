require_relative '../../v3/services/zip_archive'

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

    def git_url
      Track.new(path, track_id).repository << '/tree/master/' << slug
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
      Code.new(dir).files.reject { |file, _| ignored_files.include? file }
    end

    def ignored_files
      ["HINTS.md"]
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

    def zip(file: Tempfile.new([slug, '.zip']),
            generator: ZipArchive)
      generator.write(dir, file.path)
      file
    end

    def dir
      if File.exist?(exercises_dir)
        exercises_dir
      else
        legacy_exercises_dir
      end
    end

    private

    def legacy_exercises_dir
      File.join(language_dir, slug)
    end

    def exercises_dir
      File.join(language_dir, "exercises", slug)
    end

    def hints
      File.read(File.join(dir, 'HINTS.md')) rescue nil
    end

    def setup
      File.read(File.join(language_dir, 'SETUP.md')) rescue nil
    end

    def language_dir
      File.join(path, 'tracks', track_id)
    end

    def unknown_language?
      !File.exist?(language_dir)
    end

    def unknown_problem?
      !exists?
    end

    def meta
      @meta ||= Readme.new(slug, path, setup, hints)
    end
  end
end
