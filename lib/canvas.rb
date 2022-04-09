class Canvas
  def self.define_tag(method_name, tag = method_name, **default_attributes, &definition_block)
    define_method method_name do |inner_value="", **provided_attributes, &block|
      HtmlNode.new(tag, inner: block || inner_value, **default_attributes, **provided_attributes).to_s(self)
      instance_exec(**provided_attributes, &definition_block) if block_given?
    end
  end

  define_tag :submit_button, :button, type: :submit
  define_tag :list_item, :li
  define_tag :unordered_list, :ul
  define_tag :del

  def initialize(continuation_dictionary:)
    @continuation_dictionary = continuation_dictionary
  end

  def render(renderable)
    last_component = @registered_component
    @registered_component = renderable
    renderable.render_content_on(self)
    @registered_component = last_component unless last_component.nil?
  end

  def new_form(&block)
    action = @continuation_dictionary.add(Continuation.new(@registered_component, 'form_submission'))
    HtmlNode.new('form', action: action, method: 'post', inner: block).to_s(self)
  end

  def anchor(symbol, &block)
    href = @continuation_dictionary.add(Continuation.new(@registered_component, block || symbol))
    HtmlNode.new('a', inner: symbol.to_s, href: href).to_s(self)
    href
  end

  def text_input(attribute)
    input(attribute, 'text')
  end

  def date_input(attribute)
    input(attribute, 'date')
  end
end