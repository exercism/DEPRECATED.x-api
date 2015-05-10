module Xapi
  # NullDocs is used as documentation for non-existent track
  class NullDocs
    def content
      @content ||= Docs::DOCS_NAMES.each_with_object({}) do |doc_name, content|
        content[doc_name] = ""
      end
    end

    def available?
      false
    end
  end
end
