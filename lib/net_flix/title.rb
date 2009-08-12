module NetFlix
  class Title < Valuable

    has_value :release_year
    has_collection :genres
    has_collection :actors
    has_value :web_page
    has_collection :delivery_formats

    def initialize(xml)
      @xdoc = xml.is_a?(String) ? Nokogiri.parse( xml ) : xml
    end

    # suppported title lengths are :short (the default) and :regular.
    def title(length=:short)
      ( @xdoc / "//catalog_title/title/@#{length}" ).to_s
    end

    def synopsis
      @synopsis ||= begin 
        Crack::XML.parse(fetch_link('synopsis'))['synopsis']
      rescue
        ''
      end
    end

    def directors
      @directors ||= ( Nokogiri.parse(fetch_link('directors')) / "/people/person/name/text()" ).to_a.map(&:to_s)
    end

    def id
      @id ||= begin 
        node = @xdoc.search('id').first
        node.content if node
      end
    end

    def movie
      @movie ||= NetFlix::Movie.new(NetFlix::Request.new(:url => id ).send) if is_movie?
    end

    def is_movie?
      id =~ /movies\/(\d+)/
    end

    def to_s
      title || 'unknown title'
    end

    private
    def fetch_link(title)
      link_url = ( @xdoc / "//catalog_title/link[@title='#{title}']/@href" ).to_s
      NetFlix::Request.new(:url => link_url ).send
    end

    class << self
      def base_url
        'http://api.netflix.com/catalog/titles'
      end

      def autocomplete(params)
        (Nokogiri.parse(
          NetFlix::Request.new(:url => base_url << '/autocomplete', :parameters => params).send
        ) / '//title/@short').to_a.map(&:to_s)
      end

      def search(params)
        new((NetFlix::Request.new(:url => base_url, :parameters => params).send))
      end

      def parse(xml)
        return [] unless xml

        nxml = Nokogiri.XML(xml)
        
        titles(nxml).map do |data|
          Title.new(data)
        end
      end
      private
      def titles(noko_xml)
        titles = noko_xml.xpath('//catalog_title')
        titles.empty? ? noko_xml.xpath('//title_index_item') : titles 
      end
    end
  end # class Title
end # module NetFlix

