module NetFlix
  class Movie < Title
    RATING_PREDICATE = %w{ G PG PG-13 R NC-17 NR }.map do |rating| 
        "@term=\"#{rating}\""
    end.join(' or ')

    # not every movie has a director!
    def directors
      @directors ||= ( Nokogiri.parse(fetch_link('directors')) / "/people/person/name/text()" ).to_a.map(&:to_s)
    end

    def rating
      ( @xdoc / "//catalog_title/category[#{RATING_PREDICATE}]/@term" ).to_s
    end

    def release_year
      ( @xdoc / "//catalog_title/release_year/text()" ).to_s
    end

    def actors
      @actors ||= ActorBuilder.from_movie(@xdoc)
    end

    def self.find( params )
      if params[:id]
        new( NetFlix::Request.new(:url => params[:id]).send )
      elsif params[:term]
        search(params)
      end
    end

    protected
    # the nodes that correspond to the constructor argument
    def self.node_xpath
      "//catalog_title[contains(id/text(),'movies')]"
    end
  end
end
