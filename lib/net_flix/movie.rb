module NetFlix
  class Movie
    def initialize(xml)
      @xdoc = Nokogiri.parse( xml )
    end

    def images
      HashWithIndifferentAccess.new(Crack::XML.parse(@xdoc.xpath('/catalog_title/box_art').to_s)['box_art'])
    end

    def synopsis
      Crack::XML.parse(NetFlix::Request.new(:url => @xdoc.xpath("/catalog_title/link[@title='synopsis']/@href").to_s).send)['synopsis']
    end
  end
end
