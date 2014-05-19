module Xapi
  class Backup
    def self.restore(key)
      new(key).problems
    end

    attr_reader :key, :path
    def initialize(key, path=default_path)
      @key = key
      @path = path
    end

    def problems
      iterations.reject(&:not_found?).sort_by(&Problem::Name)
    end

    private

    def iterations
      data.map {|row|
        Iteration.new(row, Problem.new(row['track'], row['slug'], 'backup', path))
      }
    end

    def data
      ExercismIO.code_for(key)
    end

    def default_path
      '.'
    end
  end
end
