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
    setup do
      NetFlix::Request.expects(:new).with(:url => "http://api.netflix.com/catalog/titles/movies/60001220/synopsis" ).returns(stub(:send => load_fixture_file('synopsis.xml')))
    end
    should "make a request for the synopsis" do
      @movie.synopsis
    end
    should "parse it out all awesomely" do
      assert_equal @movie.synopsis, "Joyce Carol Oates' classic short story \"Where Are You Going, Where Have You Been?\" serves as the inspiration for this disturbing drama, winner of the Grand Jury Prize at the 1986 Sundance Film Festival. When sultry teen Connie (<a href=\"http://www.netflix.com/RoleDisplay/Laura_Dern/23978\">Laura Dern</a>) discovers her sexuality, the object of her affection isn't someone her age but rather the much older, mysterious Arnold Friend (<a href=\"http://www.netflix.com/RoleDisplay/Treat_Williams/99725\">Treat Williams</a>) -- who may not have the purest intentions. " 
    end
  end
end
