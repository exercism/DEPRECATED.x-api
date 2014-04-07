require './test/test_helper'
require 'xapi/markdown'

class MarkdownTest < Minitest::Test
  def test_html_from_markdown
    md = Xapi::Markdown.at('./test/fixtures/TEXT.md')
    expected = <<-HTML
<h1>OHAI</h1>

<p>Watch this:</p>
<div class=\"highlight plaintext\"><table style=\"border-spacing: 0\"><tbody><tr><td class=\"gutter gl\" style=\"text-align: right\"><pre class=\"lineno\">1</pre></td><td class=\"code\"><pre>$ go home
</pre></td></tr></tbody></table>
</div>

    HTML
    assert_equal expected.chomp, md.to_html
  end
end
