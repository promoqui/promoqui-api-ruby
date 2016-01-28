require 'pqsdk/remote_object'

module PQSDK
  # The City class provides an interface for crawlers to the v1/cities api
  # endpoint.
  class City < RemoteObject
    @endpoint = 'v1/cities'

    attr_accessor :id, :name, :inhabitants, :latitude, :longitude, :state, :country

    validates :name, presence: true

    def attributes
      {
        'name' => nil, 'inhabitants' => nil, 'latitude' => nil,
        'longitude' => nil, 'state' => nil, 'country' => nil
      }
    end

    def self.find(name)
      res = RestLayer.get(@endpoint, q: name)
      if res[0] == 200
        from_hash res[1]
      elsif res[0] == 404
        nil
      else
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      end
    end

    def self.all
      res = RestLayer.get(@endpoint)
      if res[0] == 200
        res[1].map { |city| City.from_hash(city) }
      elsif res[0] == 404
        nil
      else
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      end
    end

    def self.find_or_create(name)
      city = find(name)
      return city if city

      city = City.new
      city.name = name
      city.create!

      city
    end
  end
end
