require './test/test_helper'
require 'xapi/markdown'

class MarkdownTest < Minitest::Test
  def test_html_from_markdown
    md = Xapi::Markdown.at('./test/fixtures/TEXT.md')
    expected = <<-HTML
<h1>OHAI</h1>

<p>Watch this:</p>
<pre class=\"highlight text\"><table><tbody><tr><td class=\"gutter gl\"><div class=\"lineno\">1</div></td><td class=\"code\">$ go home
</td></tr></tbody></table></pre>
    HTML
    assert_equal expected.chomp, md.to_html
  end
end
