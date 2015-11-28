module Xapi
  # Image is a image associated with documentation of specific language
  class Image
    attr_reader :path
    def initialize(name, path)
      @name = name
      @path = File.join(path, 'img', @name)
    end

    def exists?
      File.exist?(path)
    end

    def type
      File.extname(path).sub('.', '').to_sym
    end
  end
end
