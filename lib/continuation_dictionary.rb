class ContinuationDictionary
  def initialize
    @component_actions = {}
  end

  def [](key)
    @component_actions.fetch(key.to_i)
  end

  def add(continuation)
    @component_actions[continuation.object_id] = continuation

    continuation.object_id
  end
end
