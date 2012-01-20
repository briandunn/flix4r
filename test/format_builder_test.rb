require 'test_helper'

class FormatBuilderTest < Test::Unit::TestCase

  def test_that_current_formats_are_parsed_from_full_catalog
    data = title_with_formats
    formats = FormatBuilder.from_movie(data)
    assert_included formats, 'current_format'
    assert_included formats, 'no_availability_format'
    assert_not_included formats, 'future_format'
  end

  def test_that_format_links_are_followed

    NetFlix::Request.expects(:new).with(:url => 'http://api.netflix.com/catalog/titles/movies/60031755/format_availability').returns(stub_everything(:send => '<xml/>'))

    FormatBuilder.from_movie( title_with_link_to_formats )
  end

  def test_that_cast_list_contains_current_formats
    formats = FormatBuilder.from_xml(delivery_format_list)
    assert_included formats, 'current_format'
  end

  def test_that_format_list_does_not_contain_future_formats
    formats = FormatBuilder.from_xml(delivery_format_list)
    assert_not_included formats, 'future_format'
  end

  def delivery_format_list
    %|<delivery_formats>
        <availability available_from="#{(Time.now - 2.days).to_i}">
          <category scheme="http://api.netflix.com/categories/title_formats" label="current_format" term="current_format"></category>
        </availability>
        <availability available_from="#{(Time.now + 2.days).to_i}">
          <category scheme="http://api.netflix.com/categories/title_formats" label="future_format" term="future_format"></category>
        </availability>
      </delivery_formats
    |
  end

  def title_with_link_to_formats
    xml = '<catalog_title><link href="http://api.netflix.com/catalog/titles/movies/60031755/format_availability" rel="http://schemas.netflix.com/catalog/titles/format_availability" title="formats"></link></catalog_title>'
    Nokogiri.XML(xml).search('//catalog_title')
  end

  def title_with_formats

    xml = %|<title_index_item>
              <delivery_formats>
                <availability available_from="#{(Time.now + 2.days).to_i}">
                  <category
 label="future_format" term="future_format"></category>
		</availability>
		<availability available_from="#{(Time.now - 2.days).to_i}">
                  <category scheme="http://api.netflix.com/categories/title_formats" label="current_format" term="current_format"></category>
		</availability>
                <availability>
                  <category scheme="http://api.netflix.com/categories/title_formats" label="no_availability_format" term="no_availability_format"></category>
                </availability>
              </delivery_formats>
           </title_index_item>
       |

    Nokogiri.XML(xml).search('//title_index_item')
  end
end
