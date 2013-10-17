require "test_helper"

class DummyRepresenter < Representer::Base
end

class Representer::Tests::Configuration < MiniTest::Test
  def setup
    DummyRepresenter.instance_eval do
      @representable_namespace        = nil
      @representable_namespace_plural = nil
      @representable_attributes       = nil
      @representable_methods          = nil
      @representable_fields           = nil
    end
  end

  def test_setting_of_namespace
    DummyRepresenter.namespace 'dummy'
    assert_equal 'dummy', DummyRepresenter.representable_namespace
    assert_equal 'dummys', DummyRepresenter.representable_namespace_plural
  end

  def test_setting_of_namespace_with_plural_form
    DummyRepresenter.namespace 'dummy', 'dummies'
    assert_equal 'dummy', DummyRepresenter.representable_namespace
    assert_equal 'dummies', DummyRepresenter.representable_namespace_plural
  end

  def test_setting_of_attributes
    DummyRepresenter.attributes "name", "email"
    assert_equal ["id", "name", "email"], DummyRepresenter.representable_attributes
  end

  def test_default_of_attributes
    assert_equal ["id"], DummyRepresenter.representable_attributes
  end

  def test_setting_of_methods
    DummyRepresenter.methods "first_name"
    assert_equal ["first_name"], DummyRepresenter.representable_methods
  end

  def test_setting_of_fields
    DummyRepresenter.fields "messages"
    assert_equal ["messages"], DummyRepresenter.representable_fields
  end

end
