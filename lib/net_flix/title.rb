module NetFlix
  class Title

    def initialize(xml)
      @xdoc = xml.is_a?(String) ? Nokogiri.parse( xml ) : xml
    end

    # suppported title lengths are :short (the default) and :regular.
    def title(length=:short)
      ( @xdoc / "//catalog_title/title/@#{length}" ).to_s
    end

    def images
      HashWithIndifferentAccess.new(Crack::XML.parse(@xdoc.xpath('//catalog_title/box_art').to_s)['box_art'])
    end

    def synopsis
      @synopsis ||= begin 
        Crack::XML.parse(fetch_link('synopsis'))['synopsis']
      rescue
        ''
      end
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
      NetFlix::Request.new(:url => link_url ).send unless link_url.blank?
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

      def index(file_name)
        NetFlix::Request.new( :url => NetFlix::Title.base_url + '/index').write_to_file(file_name)
      end

      def search(params)
        parse(NetFlix::Request.new(:url => base_url, :parameters => params).send)
      end

      def parse(xml)
        return [] unless xml

        nxml = Nokogiri.XML(xml)
        
        (nxml / node_xpath).map do |data|
          self.new(data.to_s)
        end
      end
      protected
      def node_xpath
        '//catalog_title'
      end
    end
  end # class Title
end # module NetFlix

