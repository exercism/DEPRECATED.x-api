module Xapi
  # Track specific documentation
  class Docs
    DOCS_NAMES = %w(hello about workflow resources installation tools)

    def initialize(path)
      @docs_dir = File.join(path, 'docs')
    end

    def content
      @content ||= DOCS_NAMES.each_with_object({}) do |doc_name, content|
        path = path_for(doc_name)
        content[doc_name] = File.exist?(path) ? File.read(path) : ""
      end
    end

    def available?
      @available = DOCS_NAMES.any? do |doc_name|
        File.exist? path_for(doc_name)
      end if @available.nil?
      @available
    end

    private

    attr_reader :docs_dir

    def path_for(doc_name)
      "#{docs_dir}/#{doc_name.upcase}.md"
    end
  end
end
