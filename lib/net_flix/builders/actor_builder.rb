class ActorBuilder

  class << self
	  
  def from_xml(xml)
    Nokogiri.XML(xml).xpath('//people/person/name').map do |actor_data|
      actor_data.content
    end
  end
  
  def from_movie(movie)
    actors = movie.search('link[@rel="http://schemas.netflix.com/catalog/person.actor"]').map{|f| f['title'] }
    
    actors + request_cast_for(movie)
  end

  def request_cast_for(movie)
    cast_link_node = movie.search('link[@rel="http://schemas.netflix.com/catalog/people.cast"]').first
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
