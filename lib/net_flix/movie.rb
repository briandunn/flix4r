module NetFlix
  class Movie < Title

    protected
    # the nodes that correspond to the constructor argument
    def self.node_xpath
      "//catalog_title[contains(id/text(),'movies')]"
    end
  end
end
