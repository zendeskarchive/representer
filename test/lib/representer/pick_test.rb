require "test_helper"

class Representer::Tests::Pick < MiniTest::Test
  class TestPickRepresenter < Representer::Base
    attributes :id, :email
    methods :method1, :method2
    fields :field1, :field2
    fields :field3 => "field3_alias"

    def field1(hash)
      "field1"
    end

    def field2(hash)
      "field2"
    end

    def field3(hash)
      "field3"
    end
  end

  def setup
    @user = User.find(1)

    @method1_result = "some computed value"
    @method2_result = "another computed value"
    @user.stubs(:method1).returns(@method1_result)
    @user.stubs(:method2).returns(@method2_result)

    @expected = {
      "id" => @user.id, "email" => @user.email,
      "method1" => @method1_result, "method2" => @method2_result,
      "field1" => "field1", "field2" => "field2", "field3_alias" => "field3"
    }
  end

  def test_pick_represents_all_fields_by_default
    assert_equal(TestPickRepresenter.new(@user).prepare, @expected)
  end

  def test_pick_represents_selected_fields_when_configured
    expected = {"field1" => @expected["field1"]}
    assert_equal(TestPickRepresenter.new(@user, :pick => ["field1"]).prepare, expected)
  end

  def test_pick_represents_selected_methods_when_configured
    expected = {"method1" => @expected["method1"]}
    assert_equal(TestPickRepresenter.new(@user, :pick => ["method1"]).prepare, expected)
  end

  def test_pick_represents_selected_attributes_when_configured
    expected = {"email" => @expected["email"]}
    assert_equal(TestPickRepresenter.new(@user, :pick => ["email"]).prepare, expected)
  end

  def test_pick_works_with_aliased_definitions
    expected = {"field3_alias" => @expected["field3_alias"]}
    assert_equal(TestPickRepresenter.new(@user, :pick => ["field3_alias"]).prepare, expected)
  end
end
