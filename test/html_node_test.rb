require 'test_helper'

class HtmlNodeTest < Minitest::Test
  def test_prevents_xss
    subject = HtmlNode.new('div', inner: '<script>alert("XSS")</script>')
    subject.to_s(canvas)
    assert_equal "<div>#{ERB::Util.html_escape('<script>alert("XSS")</script>')}</div>", canvas.to_s
  end

  def test_prevents_xss_with_block_args
    subject = HtmlNode.new('div', inner: ->(html){html.text '<script>alert("XSS")</script>'})
    subject.to_s(canvas)
    assert_equal "<div>#{ERB::Util.html_escape('<script>alert("XSS")</script>')}</div>", canvas.to_s
  end

  def canvas
    @canvas ||= HtmlCanvas.new(continuation_dictionary: ContinuationDictionary.new)
  end
end