require 'test_helper'
class ActorBuilderTest < Test::Unit::TestCase

  def test_that_actors_are_parsed
    xml = %|<title_index_item>  
                <link href="http://api.netflix.com/catalog/people/98401" rel="http://schemas.netflix.com/catalog/person.actor" title="George Wendt"></link>
		<link href="http://api.netflix.com/catalog/people/35954" rel="http://schemas.netflix.com/catalog/person.actor" title="Robert Hy Gorman"></link>
	      </title_index_item>  
           |
    data = Nokogiri.XML(xml).search('//.')	 
    assert_equal ['George Wendt', 'Robert Hy Gorman'], ActorBuilder.from_movie(data).sort
  end

  def test_that_cast_reference_is_pulled

    NetFlix::Request.expects(:new).with(:url => 'http://api.netflix.com/catalog/titles/movies/60024073/cast').returns(stub_everything(:send => '<xml/>'))
    
    xml = %|
              <title_index_item>  
                <link href="http://api.netflix.com/catalog/titles/movies/60024073/cast" rel="http://schemas.netflix.com/catalog/people.cast" title="cast"></link>
	      </title_index_item>  
           |
    data = Nokogiri.XML(xml).search('//title_index_item')

    ActorBuilder.from_movie(data)    
  end

  def test_that_cast_list_is_parsable
    xml = %|<people><person><id>http://api.netflix.com/catalog/people/20037237</id><name>Vanessa Bell Calloway</name><link href="http://api.netflix.com/catalog/people/20037237/filmography" rel="http://schemas.netflix.com/catalog/titles.filmography" title="filmography"></link><link href="http://www.netflix.com/RoleDisplay/Vanessa_Bell_Calloway/20037237" rel="alternate" title="web page"></link></person></people>|

    assert_equal ['Vanessa Bell Calloway'], ActorBuilder.from_xml(xml)
  end

end
