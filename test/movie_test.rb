require 'test_helper'
class NetFlix::MovieTest < Test::Unit::TestCase
  def setup
    @movie = Movie.new(load_fixture_file('movie.xml'))
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
end
