module NetFlix
  class Movie
    def initialize(xml)
      @xdoc = Nokogiri.parse( xml )
    end

    def images
      HashWithIndifferentAccess.new(Crack::XML.parse(@xdoc.xpath('/catalog_title/box_art').to_s)['box_art'])
    end
  end
end
