require 'forwardable'

module Xapi
  class Iteration
    extend Forwardable

    delegate [
      :language, :slug, :not_found?,
      :tests, :test_file, :readme # deprecated
    ] => :exercise

    attr_reader :data, :exercise
    def initialize(data, exercise)
      @data = data
      @exercise = exercise
    end

    def files
      data["files"].merge(exercise.files)
    end

    def fresh?
      false
    end
  end
end
