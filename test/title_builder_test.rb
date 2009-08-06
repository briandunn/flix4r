require File.join( File.dirname(__FILE__), 'test.rb')

class TitleBuilderUsingTitleIndexTest < Test::Unit::TestCase

  def test_that_id_is_parsed
    expected = 'http://api.netflix.com/catalog/titles/movies/512381'

    xml = %|<catalog_title_index>  
              <title_index_item>  
                <id>http://api.netflix.com/catalog/titles/movies/512381</id>  
              </title_index_item>  
           </catalog_title_index>  
           |
	 
    actual = TitleBuilder.from_xml(xml).first.id
    assert_equal expected, actual 
  end

  def test_that_title_is_parsed
    xml = %|<catalog_title_index>  
              <title_index_item>  
                <title>Foster Home</title>  
              </title_index_item>  
           </catalog_title_index>  
           |
	 
    assert_equal 'Foster Home', TitleBuilder.from_xml(xml).first.title
  end

  def test_that_web_page_is_parsed
    xml = %|<catalog_title_index>  
              <title_index_item>  
                <link href="myurl" rel="alternate" title="web page"></link>
              </title_index_item>  
           </catalog_title_index>  
           |
	 
    assert_equal 'myurl', TitleBuilder.from_xml(xml).first.web_page
  end

  def test_that_delivery_formats_are_parsed
    xml = %|<catalog_title_index>  
              <title_index_item>  
                <delivery_formats>
                  <availability>
                    <category scheme="http://api.netflix.com/catalog/titles/formats" label="DVD" term="DVD" status="deprecated"></category>
                    <category scheme="http://api.netflix.com/categories/title_formats" label="DVD" term="DVD"></category>
                  </availability>
	        </delivery_formats>
	      </title_index_item>  
           </catalog_title_index>  
           |
	 
    assert_equal ['DVD'], TitleBuilder.from_xml(xml).first.delivery_formats
  end


  def test_that_genres_are_parsed
    xml = %|<catalog_title_index>  
              <title_index_item>  
                <category scheme="http://api.netflix.com/categories/genres" label="Romantic Dramas" term="Romantic Dramas"></category>
                <category scheme="http://api.netflix.com/categories/genres" label="Sci-Fi Dramas" term="Sci-Fi Dramas"></category>
	      </title_index_item>  
           </catalog_title_index>  
           |
	 
    assert_equal ['Romantic Dramas', 'Sci-Fi Dramas'], TitleBuilder.from_xml(xml).first.genres.sort
  end

  def test_that_actors_are_parsed
    xml = %|<catalog_title_index>  
              <title_index_item>  
                <link href="http://api.netflix.com/catalog/people/98401" rel="http://schemas.netflix.com/catalog/person.actor" title="George Wendt"></link>
		<link href="http://api.netflix.com/catalog/people/35954" rel="http://schemas.netflix.com/catalog/person.actor" title="Robert Hy Gorman"></link>
	      </title_index_item>  
           </catalog_title_index>  
           |
	 
    assert_equal ['George Wendt', 'Robert Hy Gorman'], TitleBuilder.from_xml(xml).first.actors.sort
  end
end
class TitleBuilderUsingCatalogSearchTest < Test::Unit::TestCase

  def test_that_id_is_parsed
    expected = 'http://api.netflix.com/catalog/titles/movies/60031755'

    xml = %{<catalog_titles>
  <catalog_title>
    <id>http://api.netflix.com/catalog/titles/movies/60031755</id>
  </catalog_title>  
  </catalog_titles>
    }
	 
    actual = TitleBuilder.from_xml(xml).first.id
    assert_equal expected, actual 
  end

  def test_that_release_year_is_parsed
    xml = '<catalog_titles><catalog_title><release_year>1992</release_year></catalog_title></catalog_titles>'
    assert_equal '1992', TitleBuilder.from_xml(xml).first.release_year
  end

  def test_that_title_is_parsed
    xml = %{<catalog_titles>
  <catalog_title>
    <title short="Sneakers" regular="Sneakers"></title>
  </catalog_title>  
  </catalog_titles>
    }
	 
    assert_equal 'Sneakers', TitleBuilder.from_xml(xml).first.title
  end

  def test_that_web_page_is_parsed
    xml = %{<catalog_titles>
  <catalog_title>
    <link href="myurl" rel="alternate" title="web page"></link>
  </catalog_title>  
  </catalog_titles>
    }

    assert_equal 'myurl', TitleBuilder.from_xml(xml).first.web_page
  end

  def test_that_delivery_formats_come_from_format_builder

    FormatBuilder.stubs(:from_movie).returns('results')

    xml = %{
<catalog_titles>
  <catalog_title>
<link href="http://api.netflix.com/catalog/titles/movies/60024073/format_availability" rel="http://schemas.netflix.com/catalog/titles/format_availability" title="formats"></link>
  </catalog_title>  
  </catalog_titles>
    }
	 
    assert_equal 'results', TitleBuilder.from_xml(xml).first.delivery_formats
  end


  def test_that_genres_are_parsed
    xml = %|<catalog_title_index>  
              <title_index_item>  
                <category scheme="http://api.netflix.com/categories/genres" label="Drama" term="Drama"></category>
<category scheme="http://api.netflix.com/categories/genres" label="Family Dramas" term="Family Dramas"></category>
	      </title_index_item>  
           </catalog_title_index>  
           |
	 
    assert_equal ['Drama', 'Family Dramas'], TitleBuilder.from_xml(xml).first.genres.sort
  end

  def test_that_actors_are_parsed

    ActorBuilder.stubs(:from_movie).returns(:actor_list)

    xml = %|<catalog_title_index>  
              <title_index_item>  
                <link href="http://api.netflix.com/catalog/titles/movies/60024073/cast" rel="http://schemas.netflix.com/catalog/people.cast" title="cast"></link>
	      </title_index_item>  
           </catalog_title_index>  
           |

    assert_equal :actor_list, TitleBuilder.from_xml(xml).first.actors
  end

end
