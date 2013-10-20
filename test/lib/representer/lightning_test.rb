require "test_helper"

class Representer::Tests::Lightning < MiniTest::Test
  def setup
    @collection  = User.where({})
    @representer = LightningUserRepresenter.new(@collection)
    @hash = { "id" => 1, "email" => "peter@email.com", "name" => "Peter", "other" => "private"}
    @expected_hash = @hash.dup
    @expected_hash.delete("other")
  end

  def test_lightning_mode_convert_on_sqlite
    @collection  = User.where({})
    @representer = LightningUserRepresenter.new(@collection)
    @representer.lightning_mode = true
    connection = User.connection.instance_variable_get('@connection')
    result = connection.query(@collection.to_sql)
    connection.expects(:query).with(@collection.to_sql).returns(result)
    result = @representer.lightning_mode_convert
    assert_equal result.to_a.size, User.count
    result.collect { |item|
      keys = item.keys
      assert_includes keys, "id"
      assert_includes keys, "email"
      assert_includes keys, "name"
      assert_includes keys, "internal_secret_token"
    }
  end

  def test_lightning_mode_convert_on_mysql
    @collection  = MysqlUser.where({})
    count = MysqlUser.count
    @representer = LightningUserRepresenter.new(@collection)
    @representer.lightning_mode = true
    connection = MysqlUser.connection.instance_variable_get('@connection')
    result = connection.query(@collection.to_sql)
    connection.expects(:query).with(@collection.to_sql).returns(result)
    result = @representer.lightning_mode_convert
    assert_equal result.size, count
    result.collect { |item|
      keys = item.keys
      assert_includes keys, "id"
      assert_includes keys, "email"
      assert_includes keys, "name"
      assert_includes keys, "internal_secret_token"
    }
  end

  def test_first_pass_with_lightning_mode_on
    @representer.lightning_mode = true
    results = @representer.first_pass(@hash)
    assert_equal @representer.aggregates['id'], [1]
    assert_equal results, { "user" => @expected_hash }
  end

  def test_first_pass_with_lightning_mode_off
    @representer.lightning_mode = false
    record = mock
    record.expects(:read_attribute).with('id').returns(@hash['id'])
    record.expects(:read_attribute).with('name').returns(@hash['name'])
    record.expects(:read_attribute).with('email').returns(@hash['email'])
    results = @representer.first_pass(record)
    assert_equal @representer.aggregates['id'], [1]
    assert_equal results, { "user" => @expected_hash }
  end

  def test_respecting_the_namespace
    @representer.lightning_mode = true
    results = @representer.first_pass({})
    assert_includes results.keys, 'user'
    @representer.class.expects(:representable_namespace).returns(nil)
    results = @representer.first_pass({})
    refute_includes results.keys, 'user'
  end

  def test_extracting_the_methods
    @representer.lightning_mode = false
    @representer.class.expects(:representable_methods).returns([:some_method])
    record = MockRecord.new(:attributes => @hash)
    record.expects(:some_method)
    @representer.first_pass(record)
  end

  def test_enabling_lightning_mode
    @representer.expects(:lightning_mode_convert)
    @representer.before_prepare
    assert_equal true, @representer.lightning_mode
  end

  def test_disabling_lightning_mode_on_methods
    @representer.class.expects(:representable_methods).returns([:some_method])
    @representer.expects(:lightning_mode_convert).never
    @representer.before_prepare
    assert_equal nil, @representer.lightning_mode
  end

  def test_disabling_lightning_mode_on_fields
    @representer.class.expects(:representable_fields).returns([:some_fields])
    @representer.expects(:lightning_mode_convert).never
    @representer.before_prepare
    assert_equal nil, @representer.lightning_mode
  end

end
