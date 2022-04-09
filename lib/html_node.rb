class HtmlNode
  attr_reader :buffer, :tag_name, :attributes, :inner

  def initialize(tag_name, inner: '', **attributes)
    @tag_name = tag_name
    @attributes = attributes
    @inner = inner
  end

  def to_s(canvas)
    @canvas = canvas
    append_opening_tag
    append_inner_content
    append_closing_tag
  end

  def append(value)
    buffer << value.render
  end

  def buffer
    @canvas.buffer
  end

  private

  def append_opening_tag
    append("<#{tag_name}")

    attributes.each do |key, val|
      attribute_value = val.respond_to?(:call) ? instance_exec(&val) : val
      append(%( #{key}="#{attribute_value}"))
    end

    append(">")
  end

  def append_inner_content
    if @inner.respond_to?(:call)
      @inner.call(@canvas)
    else
      TextNode.new(inner).to_s(@canvas)
    end
  end

  def append_closing_tag
    append("</#{tag_name}>")
  end
end
