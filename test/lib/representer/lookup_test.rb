require "test_helper"

class NotloadedyetRepresenter < Representer::Base

end

class Representer::Tests::Lookup < MiniTest::Test

  def setup
    Representer.lookup_table = {}
  end

  def test_single_lookup_when_not_loaded
    Representer.expects(:lookup_constant).with("NotloadedyetRepresenter").returns("foo")
    assert_equal "foo", Representer.lookup("Notloadedyet")
  end

  def test_lookup_when_not_loaded
    namespace = mock
    foo       = mock
    moo       = mock
    Representer.expects(:lookup_constant).with("Namespace").returns(namespace)
    Representer.expects(:lookup_constant).with("Foo", namespace).returns(foo)
    Representer.expects(:lookup_constant).with("MooRepresenter", foo).returns(moo)
    assert_equal moo, Representer.lookup("Namespace::Foo::Moo")
  end

  def test_lookup_when_loaded
    begin
      Representer.lookup("Notloadedyet")
      Representer.expects(:lookup_constant).with("NotloadedyetRepresenter").never
      Representer.lookup("Notloadedyet")
    rescue
      puts $!.backtrace.join("\n")
    end
  end

end
