module Net
  class HTTP
    def self.get_json url
      resp = open(url).read
      JSON.parse resp
    end
  end
end
