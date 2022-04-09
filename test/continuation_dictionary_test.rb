require 'test_helper'

class ContinuationDictionaryTest < Minitest::Test
  def component_for_test
    Class.new(HtmlComponent) do
      attr_accessor :attr
    end.new
  end

  def test_handling_multiple_forms
    first_component = component_for_test
    second_component = component_for_test
    subject = ContinuationDictionary.new

    first_key = subject.add(Continuation.new(first_component, 'form_submission'))
    subject.add(Continuation.new(first_component, 'form_submission'))
    subject[first_key].call(attr: 'first component attr')

    assert_nil second_component.attr
    assert_equal 'first component attr', first_component.attr
  end

  def test_observability
    first_component = component_for_test
    subject = ContinuationDictionary.new
    subject.add_observer(self)
    first_key = subject.add(Continuation.new(first_component, 'form_submission'))

    subject[first_key].call({})

    assert @updated
  end

  def test_adding_block
    component = component_for_test
    subject = ContinuationDictionary.new
    key = subject.add(Continuation.new(component, lambda { |c, arg| c.attr = arg } ))

    subject[key].call('clicked')

    assert_equal 'clicked', component.attr
  end

  def update
    @updated = true
  end
end