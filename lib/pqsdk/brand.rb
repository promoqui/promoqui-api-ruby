require 'pqsdk/remote_object'

module PQSDK
  # The Brand class provides an interface for crawlers to the v1/brands api
  # endpoint.
  class Brand < RemoteObject
    @endpoint = 'v1/brands'

    attr_accessor :id, :name, :slug

    def attributes
      { 'name' => nil, 'slug' => nil }
    end

    def self.list
      res = RestLayer.get(@endpoint)
      if res[0] == 200
        res[1].map { |brand| Brand.from_json(brand) }
      elsif res[0] == 404
        nil
      else
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      end
    end

    def self.find(name)
      res = RestLayer.get("#{@endpoint}/search", q: name)
      if res[0] == 200
        Brand.from_json res[1]
      elsif res[0] == 404
        nil
      else
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      end
    end

    def self.from_json(json)
      result = Brand.new

      json.each do |key, val|
        result.send("#{key}=", val)
      end

      result
    end
  end
end
