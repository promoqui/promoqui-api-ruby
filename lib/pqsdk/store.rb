require 'active_support'
require 'active_model'

module PQSDK
  class Store
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON

    attr_accessor :id, :origin, :name, :address, :latitude, :longitude, :city, :city_id, :zipcode, :phone, :opening_hours, :opening_hours_text

    validates :origin, :name, :address, :latitude, :longitude, presence: true
    validates :city_id, presence: true, if: proc { |s| s.city.nil? }

    def attributes
      {
        'id' => nil,
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
      if !valid?
        false
      else
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
            fields[field.to_s] = send(field)
          end

          fields['city'] = city if city
          fields['city_id'] = city_id if city_id
          fields['phone'] = phone if phone
        end

        fields['opening_hours'] = opening_hours if opening_hours.is_a?(Array) && opening_hours.any?
        fields['opening_hours_text'] = opening_hours_text if opening_hours_text.is_a?(String) && opening_hours_text.strip != ""

        res = RestLayer.send(method, url, fields, { 'Authorization' => "Bearer #{Token.access_token}", 'Content-Type' => 'application/json' })

        if res[0] != expected_status
          raise Exception.new("Unexpected HTTP status code #{res[0]}, #{res[1]}")
        else
          if method == :post
            self.id = res[1]['id']
          end
        end
        true
      end
    end

    def opening_hours
      @opening_hours ||= []
    end

    private
    def self.id=(id)
      @id = id
    end

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
