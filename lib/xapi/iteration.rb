require 'forwardable'

module Xapi
  class Iteration
    extend Forwardable

    delegate [
      :id, :track_id, :language, :slug, :name, :not_found?,
    ] => :exercise

    attr_reader :data, :exercise
    def initialize(data, exercise)
      @data = data
      @exercise = exercise
    end

    def files
      exercise.files.merge(data["files"])
    end
  end
end
