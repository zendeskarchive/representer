require "test_helper"

class DummyPreparationRepresenter < Representer::Base

  attributes "name"

  def first_name(hash)
    hash["name"].split(" ").first
  end

end


class Representer::Tests::Preparation < MiniTest::Unit::TestCase
  def setup
    DummyPreparationRepresenter.instance_eval do
      @representable_fields           = nil
      @representable_methods          = nil
      @representable_namespace        = nil
    end
    @dummy  = mock(:attributes => { "id" => 1, "name" => "Olivia Dunham" })
  end

  def test_first_pass_on_single_item
    @representer = DummyPreparationRepresenter.new(@dummy)
    @dummy.expects(:some_method).returns("foo")
    DummyPreparationRepresenter.methods "some_method"
    result = @representer.prepare
    assert_equal "foo", result["some_method"]
    refute_includes result, "first_name"
  end

  def test_first_pass_on_array
    @dummy2 = mock(:attributes => { "id" => 2, "name" => "Peter Bishop" })
    @representer = DummyPreparationRepresenter.new([@dummy, @dummy2])
    @dummy.expects(:some_method).returns("foo")
    @dummy2.expects(:some_method).returns("boo")
    DummyPreparationRepresenter.methods "some_method"

    result = @representer.prepare

    assert_equal "foo", result[0]["some_method"]
    assert_equal "boo", result[1]["some_method"]
    refute_includes result[0], "first_name"
    refute_includes result[1], "first_name"
  end

  def test_first_pass_with_namespace
    @representer = DummyPreparationRepresenter.new(@dummy)
    @dummy.expects(:some_method).returns("foo")
    DummyPreparationRepresenter.methods "some_method"
    DummyPreparationRepresenter.namespace "dummy"
    result = @representer.prepare
    assert_equal ["dummy"], result.keys
    assert_equal "foo", result['dummy']["some_method"]
    refute_includes result["dummy"], "first_name"
  end

  def test_second_pass_on_single_item_without_namespace
    @representer = DummyPreparationRepresenter.new(@dummy)
    @dummy.expects(:some_method).never
    DummyPreparationRepresenter.fields "first_name"
    result = @representer.prepare
    assert_equal "Olivia", result["first_name"]
    assert_includes result, "first_name"
  end

  def test_second_pass_on_array_without_namespace
    @dummy2 = mock(:attributes => { "id" => 2, "name" => "Peter Bishop" })
    @representer = DummyPreparationRepresenter.new([@dummy, @dummy2])

    @dummy.expects(:some_method).never
    DummyPreparationRepresenter.fields "first_name"
    result = @representer.prepare
    assert_equal "Olivia", result[0]["first_name"]
    assert_includes result[0], "first_name"
    assert_equal "Peter", result[1]["first_name"]
    assert_includes result[1], "first_name"
  end

  def test_second_pass_on_single_item_with_namespace
    DummyPreparationRepresenter.namespace "dummy"
    @representer = DummyPreparationRepresenter.new(@dummy)
    @dummy.expects(:some_method).never
    DummyPreparationRepresenter.fields "first_name"
    result = @representer.prepare
    assert_equal "Olivia", result["dummy"]["first_name"]
    assert_includes result["dummy"], "first_name"
  end

  def test_second_pass_on_array_with_namespace
    DummyPreparationRepresenter.namespace "dummy"
    @dummy2 = mock(:attributes => { "id" => 2, "name" => "Peter Bishop" })
    @representer = DummyPreparationRepresenter.new([@dummy, @dummy2])

    @dummy.expects(:some_method).never
    DummyPreparationRepresenter.fields "first_name"
    result = @representer.prepare
    assert_equal "Olivia", result[0]["dummy"]["first_name"]
    assert_includes result[0]["dummy"], "first_name"
    assert_equal "Peter", result[1]["dummy"]["first_name"]
    assert_includes result[1]["dummy"], "first_name"
  end

end