require "test_helper"

class Representer::Tests::Rendering < MiniTest::Test
  def setup
    @collection  = User.where({})
    @representer = UserRepresenter.new(@collection)
  end

  def test_array_json_rendering_with_a_namespace
    assert_equal @representer.render(:json), '[{"user":{"id":1,"name":"Peter","email":"peter@email.com"}},{"user":{"id":2,"name":"Olivia","email":"olivia@email.com"}},{"user":{"id":3,"name":"Walter","email":"walter@email.com"}},{"user":{"id":4,"name":"Astrid","email":"astrid@email.com"}},{"user":{"id":5,"name":"Broyles","email":"broyles@email.com"}}]'
  end

  def test_array_json_rendering_without_a_namespace
    @representer.class.stubs(:representable_namespace).returns(false)
    assert_equal @representer.render(:json), "[{\"id\":1,\"name\":\"Peter\",\"email\":\"peter@email.com\"},{\"id\":2,\"name\":\"Olivia\",\"email\":\"olivia@email.com\"},{\"id\":3,\"name\":\"Walter\",\"email\":\"walter@email.com\"},{\"id\":4,\"name\":\"Astrid\",\"email\":\"astrid@email.com\"},{\"id\":5,\"name\":\"Broyles\",\"email\":\"broyles@email.com\"}]"
  end

  def test_single_item_json_rendering_with_a_namespace
    @collection  = User.first
    @representer = UserRepresenter.new(@collection)
    assert_equal @representer.render(:json), "{\"user\":{\"id\":1,\"name\":\"Peter\",\"email\":\"peter@email.com\"}}"
  end

  def test_single_item_json_rendering_without_a_namespace
    @collection  = User.first
    @representer = UserRepresenter.new(@collection)
    @representer.class.stubs(:representable_namespace).returns(false)
    assert_equal @representer.render(:json), "{\"id\":1,\"name\":\"Peter\",\"email\":\"peter@email.com\"}"
  end

  def test_array_xml_rendering_with_a_namespace
    assert_equal @representer.render(:xml), "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<users type=\"array\">\n  <user>\n    <id type=\"integer\">1</id>\n    <name>Peter</name>\n    <email>peter@email.com</email>\n  </user>\n  <user>\n    <id type=\"integer\">2</id>\n    <name>Olivia</name>\n    <email>olivia@email.com</email>\n  </user>\n  <user>\n    <id type=\"integer\">3</id>\n    <name>Walter</name>\n    <email>walter@email.com</email>\n  </user>\n  <user>\n    <id type=\"integer\">4</id>\n    <name>Astrid</name>\n    <email>astrid@email.com</email>\n  </user>\n  <user>\n    <id type=\"integer\">5</id>\n    <name>Broyles</name>\n    <email>broyles@email.com</email>\n  </user>\n</users>\n"
  end

  def test_array_xml_rendering_without_a_namespace
    @representer.class.stubs(:representable_namespace).returns(false)
    assert_equal @representer.render(:xml), "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<objects type=\"array\">\n  <object>\n    <id type=\"integer\">1</id>\n    <name>Peter</name>\n    <email>peter@email.com</email>\n  </object>\n  <object>\n    <id type=\"integer\">2</id>\n    <name>Olivia</name>\n    <email>olivia@email.com</email>\n  </object>\n  <object>\n    <id type=\"integer\">3</id>\n    <name>Walter</name>\n    <email>walter@email.com</email>\n  </object>\n  <object>\n    <id type=\"integer\">4</id>\n    <name>Astrid</name>\n    <email>astrid@email.com</email>\n  </object>\n  <object>\n    <id type=\"integer\">5</id>\n    <name>Broyles</name>\n    <email>broyles@email.com</email>\n  </object>\n</objects>\n"
  end

  def test_single_item_xml_rendering_with_a_namespace
    @collection  = User.first
    @representer = UserRepresenter.new(@collection)
    assert_equal @representer.render(:xml), "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<user>\n  <id type=\"integer\">1</id>\n  <name>Peter</name>\n  <email>peter@email.com</email>\n</user>\n"
  end

  def test_single_item_xml_rendering_without_a_namespace
    @collection  = User.first
    @representer = UserRepresenter.new(@collection)
    @representer.class.stubs(:representable_namespace).returns(false)
    assert_equal @representer.render(:xml), "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  <id type=\"integer\">1</id>\n  <name>Peter</name>\n  <email>peter@email.com</email>\n</hash>\n"
  end

end
