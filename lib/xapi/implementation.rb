require 'zip'

module Xapi
  # Implementation is a language-specific implementation of an exercise.
  class Implementation
    IGNORE = [
      Regexp.new("HINTS\.md$"),
      Regexp.new("example", Regexp::IGNORECASE),
      Regexp.new("\/\.$"),
    ]

    attr_reader :track_id, :repo, :problem, :root
    def initialize(track_id, repo, problem, root)
      @track_id = track_id
      @repo = repo
      @problem = problem
      @root = root
    end

    def exists?
      File.exist?(dir)
    end

    def files
      Hash[paths.map {|path|
        [filename(path), File.read(path)]
      }].merge("README.md" => readme)
    end

    def zip
      @zip ||= create_zip
    end

    def readme
      @readme ||= assemble_readme
    end

    def exercise_dir
      if File.exist?(File.join(track_dir, 'exercises'))
        File.join('exercises', problem.slug)
      else
        problem.slug
      end
    end

    def git_url
      [repo, "tree/master", exercise_dir].join("/")
    end

    private

    def filename(f)
      f.gsub(dir, "")
    end

    def paths
      Dir.glob("#{dir}**/*", File::FNM_DOTMATCH).reject {|f|
        File.directory?(f) || IGNORE.any? { |pattern| f =~ pattern }
      }
    end

    def create_zip
      Zip::OutputStream.write_buffer do |io|
        paths.each do |path|
          io.put_next_entry(filename(path))
          io.print IO.read(path)
        end
        io.put_next_entry('README.md')
        io.print readme
      end
    end

    def dir
      @dir ||= (
        # Make sure the problem directory always has the trailing slash.
        File.join(track_dir, exercise_dir) + File::SEPARATOR
      ).squeeze(File::SEPARATOR)
    end

    def track_dir
      @track_dir ||= File.join(root, 'tracks', track_id)
    end

    def assemble_readme
      <<-README
# #{problem.name}

#{problem.blurb}

#{readme_body}

#{problem.source_markdown}
      README
    end

    def readme_body
      [
        problem.description,
        track_hint,
        implementation_hint,
      ].reject(&:empty?).join("\n").strip
    end

    def track_hint
      read File.join(track_dir, 'SETUP.md')
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
