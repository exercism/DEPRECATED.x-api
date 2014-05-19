module Xapi
  module Config
    LANGUAGES = Dir.entries('./problems') - ['.', '..']

    def self.languages
      LANGUAGES
    end
  end
end
