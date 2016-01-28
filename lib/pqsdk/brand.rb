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
      all  # aliased until all crawlers use .all
    end

    def self.find(name)
      res = RestLayer.get("#{@endpoint}/search", q: name)
      if res[0] == 200
        from_hash res[1]
      elsif res[0] == 404
        nil
      else
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      end
    end
  end
end
