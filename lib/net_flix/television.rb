module NetFlix
  class Television < Title

    def actors
      @actors ||= ActorBuilder.from_movie(@xdoc)
    end

    protected
    # the nodes that correspond to the constructor argument
    def self.node_xpath
      "//catalog_title[not(contains(id/text(),'movies'))]"
    end
  end
end
