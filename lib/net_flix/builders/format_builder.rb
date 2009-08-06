class FormatBuilder

  class << self

    def from_xml(xml)

      Nokogiri.XML(xml).xpath("//delivery_formats/availability[@available_from < #{Time.now.to_i} or not(@available_from)]/category").map do |format_data|

        format_data['term']
      end
    end

    def from_movie(movie)

      	    formats = movie.xpath("//title_index_item/delivery_formats/availability[not(@available_from) or @available_from < #{Time.now.to_i}]/category[@scheme='http://api.netflix.com/categories/title_formats']").map{|f| f['term'] }
	    formats + request_cast_for(movie)

    end

    def request_cast_for(movie)
      cast_link_node = movie.search('link[@rel="http://schemas.netflix.com/catalog/titles/format_availability"]').first
      cast_link = cast_link_node['href'] if cast_link_node

      if cast_link.nil?
        []
      else
        request = NetFlix::Request.new(:url => cast_link)
        response = request.send
        from_xml(response)
      end
    end
  end
end
