module Xapi
  class Iteration < OpenStruct
    def language
      track
    end

    def fresh?
      false
    end
  end
end
