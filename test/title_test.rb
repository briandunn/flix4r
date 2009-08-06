require 'test_helper'
class TitleTest < Test::Unit::TestCase

  def request_stub
    stub_everything(:send => '<xml />')
  end

  def test_that_title_can_go_to_and_from_json
    expected = NetFlix::Title.new()

    actual = NetFlix::Title.from_json( expected.to_json )

    assert_equal expected.id, actual.id
    assert_equal expected.delivery_formats, actual.delivery_formats
  end
end
