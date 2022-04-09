class ContinuationDictionary
  def initialize
    @component_actions = {}
  end

  def [](key)
    @component_actions.fetch(key.to_i)
  end

  def add(continuation)
    continuation.add_observer(@observer)
    @component_actions[continuation.object_id] = continuation

    continuation.object_id
  end

  def add_observer(observer)
    @observer = observer
  end
end