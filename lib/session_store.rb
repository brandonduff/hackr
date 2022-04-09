require 'ostruct'

class SessionStore
  attr_accessor :continuations

  def initialize(component_factory, continuations)
    @sessions = {}
    @id = 1
    @component_factory = component_factory
    @continuations = continuations
  end

  def new_session
    OpenStruct.new(id: next_id, component: @component_factory.new, continuations: continuations).tap do |session|
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
end