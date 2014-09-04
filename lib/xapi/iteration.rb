require 'forwardable'

module Xapi
  class Iteration
    extend Forwardable

    delegate [
      :track_id, :language, :slug, :name, :not_found?,
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
