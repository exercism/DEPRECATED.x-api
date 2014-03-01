module Xapi
  module Config
    LANGUAGES = Dir.entries('./exercises') - ['.', '..']

    def self.languages
      LANGUAGES
    end
  end
end
