class Continuation
  def initialize(component, block_or_symbol)
    @component = component
    @block_or_symbol = block_or_symbol
  end

  def call(*args)
    invoke(args)
  end

  private

  def invoke(args)
    if @block_or_symbol.is_a?(Proc)
      @block_or_symbol.call(@component, *args)
    else
      @component.send(@block_or_symbol, *args)
    end
  end
end
