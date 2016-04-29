require 'pqsdk/remote_object'

module PQSDK
  # The Store class provides an interface for crawlers to the v1/stores api
  # endpoint.
  class Store < RemoteObject
    @endpoint = 'v1/stores'

    attr_accessor :id, :origin, :name, :address, :latitude, :longitude, :city,
                  :city_id, :zipcode, :phone, :opening_hours, :opening_hours_text, :region

    validates :origin, :name, :address, presence: true
    validates :city_id, presence: true, if: proc { |s| s.city.nil? }

    def attributes
      {
        'origin' => nil, 'name' => nil, 'address' => nil, 'latitude' => nil,
        'longitude' => nil, 'city' => nil, 'city_id' => nil, 'zipcode' => nil,
        'phone' => nil, 'opening_hours' => nil, 'opening_hours_text' => nil, 'region' => nil
      }
    end

    def opening_hours
      @opening_hours ||= []
    end

    def self.find(address, zipcode, retailer = nil)
      res = RestLayer.get(@endpoint, { address: address, zipcode: zipcode, retailer: retailer }, 'Authorization' => "Bearer #{Token.access_token}")
      if res[0] == 200
        from_hash res[1]
      elsif res[0] == 404
        nil
      else
        raise "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      end
    end

    def self.from_hash(json)
      super(json.stringify_keys.except('city'))
    end
  end
end
