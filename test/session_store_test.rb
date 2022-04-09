require 'test_helper'

class SessionStoreTest < Minitest::Test
  def component_factory
    @component_factory ||= Object.new.tap do |o|
      def o.new
        self
      end
    end
  end

  def continuations
    @continuations ||= ContinuationDictionary.new
  end

  def test_retrieving_session
    subject = SessionStore.new(component_factory, continuations)
    session = subject.new_session
    other_session = subject.new_session
    assert_equal session, subject.find(session.id)
    assert_equal other_session, subject.find(other_session.id)
    refute_equal session, other_session
  end

  def test_creating_session_accepts_a_component
    component = component_factory.new
    subject = SessionStore.new(component_factory, continuations)
    session = subject.new_session
    assert_equal component, session.component
  end
end