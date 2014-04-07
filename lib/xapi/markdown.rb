require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

module Xapi
  class Renderer < Redcarpet::Render::XHTML
    def lexer
      Rouge::Lexers::PlainText
    end

    def formatter
      @formatter ||= Rouge::Formatters::HTML.new(
        :css_class => "highlight #{lexer.tag}",
        :line_numbers => true
      )
    end

    def block_code(code, _)
      formatter.format(lexer.lex(code))
    end
  end

  class Markdown
    def self.at(path)
      new File.read(path)
    end

    attr_reader :text
    def initialize(text)
      @text = text
    end

    def to_html
      markdown.render(text)
    end

    private

    def markdown
      @markdown ||= Redcarpet::Markdown.new(Renderer.new(hard_wrap: true), options)
    end

    def options
      {
        fenced_code_blocks: true,
        no_intra_emphasis: true,
        autolink: true,
        strikethrough: true,
        lax_html_blocks: true,
        superscript: true,
        tables: true,
        space_after_headers: true,
        xhtml: true
      }
    end
  end
end
