class HtmlComponent
  def render(continuation_dictionary: ContinuationDictionary.new)
    canvas = HtmlCanvas.new(continuation_dictionary: continuation_dictionary)
    canvas.render(self)
    canvas.to_s
  end

  def form_submission(params)
    params.each do |k, v|
      send("#{k}=", v)
    end
  end

  def value_for(attribute)
    if respond_to?(attribute)
      send(attribute)
    else
      ''
    end
  end
end

class Object
  def render
    to_s
  end
end
