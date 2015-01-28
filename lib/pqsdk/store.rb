module PQSDK
  class Store
    attr_accessor :id, :name, :address, :zipcode, :latitude, :longitude, :phone, :city_id, :origin, :opening_hours, :leaflet_ids

    def initialize
      self.leaflet_ids = []
      self.opening_hours = []
    end

    def self.find(address, zipcode, retailer = nil)
      res = RestLayer.get('v1/stores', { address: address, zipcode: zipcode, retailer: retailer }, { 'Authorization' => "Bearer #{Token.access_token}" })
      if res[0] == 200
        Store.from_json res[1]
      elsif res[0] == 404
        nil
      else
        raise Exception.new("Unexpected HTTP status code #{res[0]}")
      end
    end

    def self.get(id)
      res = RestLayer.get("v1/stores/#{id}", { }, { 'Authorization' => "Bearer #{Token.access_token}" })
      if res[0] == 200
        Store.from_json res[1]
      elsif res[0] == 404
        nil
      else
        raise Exception.new("Unexpected HTTP status code #{res[0]}")
      end
    end

    def save
      if self.id != nil
        method = :put
        url = "v1/stores/#{self.id}"
        expected_status = 200
      else
        method = :post
        url = "v1/stores"
        expected_status = 201
      end

      fields = {}
      [ :name, :address, :zipcode, :latitude, :longitude, :city_id, :origin ].each do |field|
        raise "Missing required #{field} field" if send(field).to_s == ''
        fields[field.to_s] = send(field)
      end

      raise "Missing required leaflet_ids field" if leaflet_ids.is_a? String or leaflet_ids.to_a.empty?
      fields['leaflet_ids'] = leaflet_ids.to_json

      fields['phone'] = phone unless phone.nil?
      fields['opening_hours'] = opening_hours.to_json unless opening_hours.to_a.empty?

      res = RestLayer.send(method, url, fields, { 'Authorization' => "Bearer #{Token.access_token}" })

      if res[0] != expected_status
        raise Exception.new("Unexpected HTTP status code #{res[0]}")
      else
        if method == :post
          self.id = res[1]['id']
        end
      end
    end

  private
    def self.from_json(json)
      result = Store.new

      json.each do |key, val|
        if key != 'country' && key != 'city'
          result.send("#{key}=", val)
        end
      end

      result.city_id = PQSDK::City.find(json['city']).id

      result
    end
  end
end
