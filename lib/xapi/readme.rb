module Xapi
  # Readme combines metadata into a README for a problem.
  class Readme
    attr_reader :slug, :dir, :help, :exercise_help

    def initialize(slug, dir="./tracks", help=nil, exercise_help=nil)
      @slug = slug
      @dir = dir
      @help = help
      @exercise_help = exercise_help
    end

    def name
      @name ||= slug.split('-').map(&:capitalize).join(' ')
    end

    def text
      @text ||= <<-README
# #{name}

#{blurb}

#{exercise_guide}
## Source

#{source} [view source](#{source_url})
README
    end

    def blurb
      data['blurb']
    end

    private

    def exercise_guide
      [instructions, exercise_help, help].compact.join("\n")
    end

    def source
      data['source']
    end

    def source_url
      data['source_url']
    end

    def instructions
      read "#{slug}.md"
    end

    def data
      @data ||= YAML.load read "#{slug}.yml"
    end

    def read(file)
      File.read path_to(file)
    end

    def path_to(file)
      File.join(dir, 'metadata', file)
    end
  end
end
