module PQSDK
  class Store
    attr_accessor :id, :name, :city, :address, :zipcode, :latitude, :longitude, :phone, :city_id, :origin, :opening_hours, :opening_hours_text, :leaflet_ids

    def initialize(params = {})
      params.each do |key, val|
        send("#{key}=", val)
      end

      self.leaflet_ids ||= []
      self.opening_hours ||= []
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

    def self.get(id)
      res = RestLayer.get("v1/stores/#{id}", { }, { 'Authorization' => "Bearer #{Token.access_token}" })
      if res[0] == 200
        Store.from_json res[1]
      elsif res[0] == 404
        nil
      else
        raise Exception.new("Unexpected HTTP status code #{res[0]}, #{res[1]}")
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

      if city.nil? and city_id.nil?
        raise "city or city_id must be set"
      end

      fields = {}
      if method != :put
        [ :name, :address, :zipcode, :latitude, :longitude, :origin ].each do |field|
          raise "Missing required #{field} field" if send(field).to_s == ''
          fields[field.to_s] = send(field)
        end

        fields['city'] = city if city
        fields['city_id'] = city_id if city_id
        fields['phone'] = phone if phone
      end

      fields['opening_hours'] = opening_hours if opening_hours.is_a?(Array) && opening_hours.any?
      fields['opening_hours_text'] = opening_hours_text if opening_hours_text

      res = RestLayer.send(method, url, fields, { 'Authorization' => "Bearer #{Token.access_token}", 'Content-Type' => 'application/json' })

      if res[0] != expected_status
        raise Exception.new("Unexpected HTTP status code #{res[0]}, #{res[1]}")
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
        if respond_to?("#{key}=")
          if key != 'country' && key != 'city'
            result.send("#{key}=", val)
          end
        else
          if key != 'country' && key != 'city' && key != 'retailer_id'
            result.send("#{key}=",val)
          end
        end
      end

      result
    end
  end
end
