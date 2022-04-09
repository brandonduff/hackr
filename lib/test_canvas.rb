class TestCanvas < Canvas
  def self.build
    new(continuation_dictionary: ContinuationDictionary.new)
  end

  def self.define_tags(*tags)
    tags.each do |tag|
      define_tag(tag)
    end
  end

  def self.define_tag(tag_name)
    define_method tag_name do |*args, &block|
      if block
        sub_canvas = TestCanvas.build
        rendered[tag_name] << sub_canvas
        block.call(sub_canvas)
      else
        rendered[tag_name] << args.first
      end
    end
  end

  define_tags :list_item, :paragraph, :del, :submit_button, :text, :h1

  def include?(content)
    rendered?(content)
  end

  def ==(other)
    include?(other)
  end

  def rendered?(args)
    if args.is_a?(Hash)
      args.all? do |tag, content|
        rendered[tag].include?(content)
      end
    else
      rendered.values.flatten.include?(args)
    end
  end

  def input(attribute, _type)
    value = component.value_for(attribute)
    rendered[:input] << [attribute, value]
  end

  def anchor(symbol)
    href = super
    rendered[:anchor] << [symbol, href]
  end

  def new_form(&block)
    super
    @form_rendered = true
  end

  def inputs(name)
    rendered[:input].find(-> { raise 'no input with that name' }) { |k, _v| k == name }[1]
  end

  def fill_in(input, value)
    raise 'no form defined' unless @form_rendered
    inputs(input) and (params[input] = value)
  end

  def submit
    raise 'no submit button' if rendered[:submit_button].empty?
    component.form_submission(params)
    clear
    render(component)
  end

  def rendered
    @rendered ||= blank_rendering
  end

  def click(value)
    entry = rendered[:anchor].find { |v| v[0] == value }
    raise "no anchor tag with value #{value}" unless entry

    @continuation_dictionary[entry[1]].call
    clear
    render(component)
  end

  def buffer
    @buffer ||= ''
  end

  private

  def clear
    @rendered = blank_rendering
  end

  def blank_rendering
    Hash.new { |hash, key| hash[key] = [] }
  end

  def component
    @registered_component
  end

  def params
    @params ||= {}
  end
end