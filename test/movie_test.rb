require 'test_helper'
class NetFlix::MovieTest < Test::Unit::TestCase
  def setup
    @movie = NetFlix::Movie.new(load_fixture_file('movies.xml'))
  end
  context "images" do
    should "return an image url for the sizes small, medium, and large" do 
      %w{ small medium large }.each do |size|
        assert_nothing_raised 'valid url' do
          URI::parse(@movie.images[size])
        end
        assert_match(/\.jpg$/, @movie.images[size], 'looks like an image')
      end
    end
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
    setup do
    end
    should "return an array of movies" do
    end
  end

end
