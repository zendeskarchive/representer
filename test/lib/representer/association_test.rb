require "test_helper"

class Representer::Tests::Association < MiniTest::Test

  def test_has_many_association_fields
    fields = AssociatedMessageRepresenter.representable_fields
    assert_includes fields, 'attachments'
  end

  def test_has_many_association_aggregate
    fields = AssociatedMessageRepresenter.representable_fields
    assert_includes fields, 'attachments'
  end

  def test_belongs_to_association_fields
    fields = AssociatedMessageRepresenter.representable_fields
    assert_includes fields, 'user'
  end

end
