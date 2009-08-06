require File.join( File.dirname(__FILE__), 'test.rb')

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

  def test_that_search_uses_api_and_builder
    NetFlix::API::Catalog::Titles.stubs(:search).returns(:xml_results)
    TitleBuilder.expects(:from_xml).with(:xml_results).returns(:movies)
    assert_equal :movies, NetFlix::Title.search(:term)
  end

  def test_that_complete_list_call_uses_api
    NetFlix::API::Catalog::Titles.expects(:index).returns('<xml />')
    NetFlix::Title.complete_list
  end

end
