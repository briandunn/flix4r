require 'test_helper'
class TitleTest < Test::Unit::TestCase

=begin
  def test_that_title_can_go_to_and_from_json
    expected = NetFlix::Title.new(load_fixture_file('titles.xml'))

    actual = NetFlix::Title.from_json( expected.to_json )

    assert_equal expected.id, actual.id
    assert_equal expected.delivery_formats, actual.delivery_formats
  end
=end

  context "autocomplete" do

    should "return an array of titles" do
      NetFlix::Request.expects(:new).returns(stub( :send => load_fixture_file('autocomplete.xml' )))

      assert_equal ["Love Wrecked", "Lovesickness", "Loverboy" ], NetFlix::Title.autocomplete( 'ignored' )
    end
  end

  context "instance methods" do
    setup do
      @title = NetFlix::Title.parse(load_fixture_file('titles.xml')).first
    end
    context "title" do
      should "be the title of the movie" do
        assert_equal @title.title, 'Jaws'
      end
    end
    context "images" do
      should "return an image url for the sizes small, medium, and large" do
        %w{ small medium large }.each do |size|
          assert_nothing_raised 'valid url' do
            URI::parse(@title.images[size])
          end
          assert_match(/\.jpg$/, @title.images[size], 'looks like an image')
        end
      end
    end

    context "synopsis" do
      should "default to blank" do
        assert_equal NetFlix::Title.new('').synopsis, ''
      end
      should "make a request for the synopsis" do
        mock_next_response("http://api.netflix.com/catalog/titles/movies/60001220/synopsis", 'synopsis.xml')
        @title.synopsis
      end
      should "parse it out all awesomely" do
        mock_next_response("http://api.netflix.com/catalog/titles/movies/60001220/synopsis", 'synopsis.xml')
        assert_equal @title.synopsis, "Joyce Carol Oates' classic short story \"Where Are You Going, Where Have You Been?\" serves as the inspiration for this disturbing drama, winner of the Grand Jury Prize at the 1986 Sundance Film Festival. When sultry teen Connie (<a href=\"http://www.netflix.com/RoleDisplay/Laura_Dern/23978\">Laura Dern</a>) discovers her sexuality, the object of her affection isn't someone her age but rather the much older, mysterious Arnold Friend (<a href=\"http://www.netflix.com/RoleDisplay/Treat_Williams/99725\">Treat Williams</a>) -- who may not have the purest intentions. " 
      end
    end
  end

end
