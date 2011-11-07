require "test_helper"

class NotloadedyetRepresenter < Representer::Base

end

class Representer::Tests::Lookup < MiniTest::Unit::TestCase

  def setup
    Representer.lookup_table = {}
  end

  def test_lookup_when_not_loaded
    Object.expects(:const_get).with("NotloadedyetRepresenter").returns("foo")
    assert_equal "foo", Representer.lookup("Notloadedyet")
  end

  def test_lookup_when_loaded
    Representer.lookup("Notloadedyet")
    Object.expects(:const_get).with("NotloadedyetRepresenter").never
    Representer.lookup("Notloadedyet")
  end

end
