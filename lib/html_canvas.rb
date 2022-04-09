class HtmlCanvas < Canvas
  define_tag :form, method: :post
  define_tag :hidden_input, :input, type: :text, hidden: true
  define_tag :paragraph, :p
  define_tag :label
  define_tag :list_item, :li
  define_tag :unordered_list, :ul
  define_tag :div
  define_tag :stylesheet_link, :link, rel: :stylesheet, type: 'text/css'
  define_tag :head
  define_tag :body

  def input(attribute, type)
    value = @registered_component.value_for(attribute)
    HtmlNode.new('input', name: attribute.to_s, type: type, value: value).to_s(self)
  end

  def text(value)
    TextNode.new(value).to_s(self)
  end

  def to_s
    buffer
  end

  def buffer
    @buffer ||= ''
  end
end
