require 'pathname'
require_relative 'file_bundle'
module Xapi
  # Implementation is a language-specific implementation of an exercise.
  class Implementation
    IGNORE = [
      Regexp.new("HINTS\.md$"),
      Regexp.new("example", Regexp::IGNORECASE),
      Regexp.new("\/\.$"),
    ]

    attr_reader :track_id, :repo, :problem, :root
    attr_writer :files
    def initialize(track_id, repo, problem, root)
      @track_id = track_id
      @repo = repo
      @problem = problem
      @root = Pathname.new(root)
    end

    def exists?
      File.exist?(dir)
    end

    def files
      @files ||= Hash[FileBundle.paths(dir, IGNORE).map {|path|
        [path.relative_path_from(dir).to_s, File.read(path)]
      }].merge("README.md" => readme)
    end

    def zip
      @zip ||= FileBundle.create_zip(dir, FileBundle.paths(dir, IGNORE)) do |io|
        io.put_next_entry('README.md')
        io.print readme
      end
    end

    def readme
      @readme ||= assemble_readme
    end

    def exercise_dir
      if File.exist?(track_dir.join('exercises'))
        File.join('exercises', problem.slug)
      else
        problem.slug
      end
    end

    def git_url
      [repo, "tree/master", exercise_dir].join("/")
    end

    private

    def dir
      @dir ||= track_dir.join(exercise_dir)
    end

    def track_dir
      @track_dir ||= root.join('tracks', track_id)
    end

    def assemble_readme
      <<-README
# #{problem.name}

#{problem.blurb}

#{readme_body}

#{problem.source_markdown}

#{incomplete_solutions_body}
      README
    end

    def readme_body
      [
        problem.description,
        track_hint,
        implementation_hint,
      ].reject(&:empty?).join("\n").strip
    end

    def incomplete_solutions_body
      <<-README
## Submitting Incomplete Problems
It's possible to submit an incomplete solution so you can see how others have completed the exercise.
      README
    end

    def track_hint
      read track_dir.join('SETUP.md')
    end

    def implementation_hint
      read File.join(dir, 'HINTS.md')
    end

    def read(f)
      if File.exist?(f)
        File.read(f)
      else
        ""
      end
    end
  end
end
