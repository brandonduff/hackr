require "ostruct"

class SessionStore
  attr_accessor :continuations

  def initialize(component_factory, continuations, initial_state = nil)
    @sessions = {}
    @id = 1
    @component_factory = component_factory
    @continuations = continuations
    @initial_state = initial_state
  end

  def new_session
    OpenStruct.new(id: next_id, component: new_component, continuations: continuations).tap do |session|
      @sessions[session.id] = session
    end
  end

  def find(id)
    @sessions[id]
  end

  private

  def next_id
    @id += 1
  end

  def new_component
    if @initial_state
      @component_factory.new(@initial_state)
    else
      @component_factory.new
    end
  end
end
