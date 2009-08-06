module NetFlix
  class Title < Valuable

    has_value :id
    has_value :release_year
    has_collection :genres
    has_collection :actors
    has_value :title
    has_value :web_page
    has_collection :delivery_formats

    def movie
      @movie ||= NetFlix::Movie.new(NetFlix::Request.new(:url => id ).send) if id =~ /movies\/(\d+)/
    end

    def to_json
      attributes.to_json
    end

    def self.from_json(data)
      self.new(JSON.parse(data))
    end

    def to_s
      title || 'unknown title'
    end

    class << self

      def search(params)
        TitleBuilder.from_xml(NetFlix::Request.new(:url => 'http://api.netflix.com/catalog/titles', :parameters => params).send)
      end

    end
  end # class Title
end # module NetFlix

