require "test_helper"

class SimpleRepresenter < Representer::Base
end
class Representer::Tests::Extensions < MiniTest::Unit::TestCase

  def setup
    Representer.lookup_table = {}
    @users = User.limit(2)
  end

  def test_represent_when_representer_is_provided
    assert_equal @users.first.represent(:json, :representer => SimpleRepresenter), '{"id":1}'
  end

  def test_represent_when_representer_is_provided
    assert_equal @users.first.represent(:xml, :representer => SimpleRepresenter), "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  <id type=\"integer\">1</id>\n</hash>\n"
  end

  def test_represent_on_array_in_json
    assert_equal @users.all.represent(:json), '[{"user":{"id":1,"name":"Peter","email":"peter@email.com"}},{"user":{"id":2,"name":"Olivia","email":"olivia@email.com"}}]'
  end

  def test_represent_on_active_record_in_json
    assert_equal @users.first.represent(:json), '{"user":{"id":1,"name":"Peter","email":"peter@email.com"}}'
  end

  def test_represent_on_active_record_relation_in_json
    assert_equal @users.represent(:json), '[{"user":{"id":1,"name":"Peter","email":"peter@email.com"}},{"user":{"id":2,"name":"Olivia","email":"olivia@email.com"}}]'
  end

  def test_represent_on_array_in_xml
    assert_equal @users.all.represent(:xml), "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<users type=\"array\">\n  <user>\n    <id type=\"integer\">1</id>\n    <name>Peter</name>\n    <email>peter@email.com</email>\n  </user>\n  <user>\n    <id type=\"integer\">2</id>\n    <name>Olivia</name>\n    <email>olivia@email.com</email>\n  </user>\n</users>\n"
  end

  def test_represent_on_active_record_in_xml
    assert_equal @users.first.represent(:xml), "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<user>\n  <id type=\"integer\">1</id>\n  <name>Peter</name>\n  <email>peter@email.com</email>\n</user>\n"
  end

  def test_represent_on_active_record_relation_in_xml
    assert_equal @users.represent(:xml), "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<users type=\"array\">\n  <user>\n    <id type=\"integer\">1</id>\n    <name>Peter</name>\n    <email>peter@email.com</email>\n  </user>\n  <user>\n    <id type=\"integer\">2</id>\n    <name>Olivia</name>\n    <email>olivia@email.com</email>\n  </user>\n</users>\n"
  end

end
