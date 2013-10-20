require "test_helper"

class Representer::Tests::Simple < MiniTest::Test

  def test_aggregation
    scope = Message.where({})
    representer = SimpleMessageRepresenter.new(scope)
    peter, olivia = representer.prepare
    assert_equal "Peter", peter['user']['name']
    assert_equal "Olivia", olivia['user']['name']
    assert_equal "photo.jpg", peter['attachments'].first['filename']
    assert_equal "song.mp3", olivia['attachments'].first['filename']
  end


end
