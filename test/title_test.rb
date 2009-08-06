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

  context "autocomplete" do

    should "return an array of titles" do
      NetFlix::Request.expects(:new).returns(stub( :send => load_fixture_file('autocomplete.xml' )))

      assert_equal ["Love Wrecked", "Lovesickness", "Loverboy" ], NetFlix::Title.autocomplete( 'ignored' ) 
    end
  end

end
