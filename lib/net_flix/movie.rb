module NetFlix
  class Movie < Title
    RATING_PREDICATE = %w{ G PG PG-13 R NC-17 NR }.map do |rating| 
        "@term=\"#{rating}\""
    end.join(' or ')

    def images
      HashWithIndifferentAccess.new(Crack::XML.parse(@xdoc.xpath('/catalog_title/box_art').to_s)['box_art'])
    end

    def rating
      ( @xdoc / "/catalog_title/category[#{RATING_PREDICATE}]/@term" ).to_s
    end

    def release_year
      ( @xdoc / "/catalog_title/release_year/text()" ).to_s
    end

    def actors
      @actors ||= ActorBuilder.from_movie(@xdoc)
    end

    def self.find( params )
      if params[:id]
        new( NetFlix::Request.new(:url => params[:id]).send )
      elsif params[:term]
        Title.search(params).select(&:is_movie?)
      end
    end
  end
end
