require 'test_helper'
class NetFlix::MovieTest < Test::Unit::TestCase
  def setup
    @movie = NetFlix::Movie.new(load_fixture_file('movies.xml'))
  end
  context "rating" do
    should "be the rating of the movie" do 
      assert_equal @movie.rating, 'PG'
    end
  end

  context "release_year" do
    should "be the release year" do
      assert_equal @movie.release_year, '1975'
    end
  end

  context "directors" do
    should "be the an array with the name of a director" do
      mock_next_response("http://api.netflix.com/catalog/titles/movies/60001220/directors", 'directors.xml' ) 
      assert_equal [ "Steven Spielberg" ], @movie.directors
    end
  end

  context "actors" do
    setup do
      mock_next_response("http://api.netflix.com/catalog/titles/movies/60001220/cast", 'cast.xml')
    end
    should "be an array of actor names" do
      ['Roy Scheider','Richard Dreyfuss'].each do |actor|
        assert @movie.actors.include?(actor) 
      end
    end
  end

  context "find" do
    should "return an array of movies" do
      NetFlix::Request.expects(:new).returns(stub(:send => load_fixture_file('titles.xml')))
      NetFlix::Movie.find( :term => 'pants' ).each do |movie|
        assert_equal NetFlix::Movie, movie.class
      end
    end
  end

end
