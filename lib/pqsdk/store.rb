require 'pqsdk/remote_object'

module PQSDK
  class Store < RemoteObject
    @endpoint = "v1/stores"

    attr_accessor :id, :origin, :name, :address, :latitude, :longitude, :city, :city_id, :zipcode, :phone, :opening_hours, :opening_hours_text

    validates :origin, :name, :address, :latitude, :longitude, presence: true
    validates :city_id, presence: true, if: proc { |s| s.city.nil? }

    def attributes
      {
        'origin' => nil,
        'name' => nil,
        'address' => nil,
        'latitude' => nil,
        'longitude' => nil,
        'city' => nil,
        'city_id' => nil,
        'zipcode' => nil,
        'phone' => nil,
        'opening_hours' => nil,
        'opening_hours_text' => nil
      }
    end

    def opening_hours
      @opening_hours ||= []
    end

    def self.find(address, zipcode, retailer = nil)
      res = RestLayer.get('v1/stores', { address: address, zipcode: zipcode, retailer: retailer }, { 'Authorization' => "Bearer #{Token.access_token}" })
      if res[0] == 200
        Store.from_json res[1]
      elsif res[0] == 404
        nil
      else
        raise Exception.new("Unexpected HTTP status code #{res[0]}, #{res[1]}")
      end
    end

    private
    def self.from_json(json)
      result = Store.new

      json.each do |key, val|
        if result.respond_to?("#{key}=") && key != 'city'
          result.send("#{key}=", val)
        end
      end

      result
    end
  end
end
