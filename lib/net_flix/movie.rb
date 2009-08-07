module NetFlix
  class Movie
    RATING_PREDICATE = %w{ G PG PG-13 R NC-17 }.map do |rating| 
        "@term=\"#{rating}\""
    end.join(' or ')

    def initialize(xml)
      @xdoc = Nokogiri.parse( xml )
    end

    def images
      HashWithIndifferentAccess.new(Crack::XML.parse(@xdoc.xpath('/catalog_title/box_art').to_s)['box_art'])
    end

    def rating
      ( @xdoc / "/catalog_title/category[#{RATING_PREDICATE}]/@term" ).to_s
    end

    def synopsis
      Crack::XML.parse(NetFlix::Request.new(:url => @xdoc.xpath("/catalog_title/link[@title='synopsis']/@href").to_s).send)['synopsis']
    end

    # suppported title lengths are :short (the default) and :regular.
    def title(length=:short)
      ( @xdoc / "/catalog_title/title/@#{length}" ).to_s
    end

    def release_year
      ( @xdoc / "/catalog_title/release_year/text()" ).to_s
    end

    def actors
      @actors ||= ActorBuilder.from_movie(@xdoc)
    end

  end
end
