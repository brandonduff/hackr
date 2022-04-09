class TextNode
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_s(canvas)
    canvas.buffer << ERB::Util.html_escape(value.render)
  end
end
