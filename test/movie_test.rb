require 'test_helper'
class NetFlix::MovieTest < Test::Unit::TestCase
  def setup
    @movie = NetFlix::Movie.new(load_fixture_file('movie.xml'))
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

  context "synopsis" do
    should "default to blank" do
      assert_equal Movie.new('').synopsis, ''
    end
    should "make a request for the synopsis" do
      mock_next_response("http://api.netflix.com/catalog/titles/movies/60001220/synopsis", 'synopsis.xml')
      @movie.synopsis
    end
    should "parse it out all awesomely" do
      mock_next_response("http://api.netflix.com/catalog/titles/movies/60001220/synopsis", 'synopsis.xml')
      assert_equal @movie.synopsis, "Joyce Carol Oates' classic short story \"Where Are You Going, Where Have You Been?\" serves as the inspiration for this disturbing drama, winner of the Grand Jury Prize at the 1986 Sundance Film Festival. When sultry teen Connie (<a href=\"http://www.netflix.com/RoleDisplay/Laura_Dern/23978\">Laura Dern</a>) discovers her sexuality, the object of her affection isn't someone her age but rather the much older, mysterious Arnold Friend (<a href=\"http://www.netflix.com/RoleDisplay/Treat_Williams/99725\">Treat Williams</a>) -- who may not have the purest intentions. " 
    end
  end

  context "rating" do
    should "be the rating of the movie" do 
      assert_equal @movie.rating, 'PG'
    end
  end

  context "title" do
    should "be the title of the movie" do
      assert_equal @movie.title, 'Jaws' 
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
