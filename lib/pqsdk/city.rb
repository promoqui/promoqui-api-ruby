module PQSDK
  class City
    attr_accessor :id, :name, :inhabitants, :latitude, :longitude, :state, :country

    def self.find(name)
      res = RestLayer.get('v1/cities', { q: name }, 'Authorization' => "Bearer #{Token.access_token}")
      if res[0] == 200
        City.from_json res[1]
      elsif res[0] == 404
        nil
      else
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      end
    end

    def self.all
      res = RestLayer.get('v1/cities', {}, 'Authorization' => "Bearer #{Token.access_token}")
      if res[0] == 200
        cities = []
        res[1].each do |city|
          cities << City.from_json(city)
        end
        return cities
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
      city.save

      city
    end

    def save
      res = RestLayer.post('v1/cities', { name: name }, 'Authorization' => "Bearer #{Token.access_token}")

      if res[0] != 201
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      else
        self.id = res[1]['id']
      end
    end

    def self.from_json(json)
      result = City.new

      json.each do |key, val|
        result.send("#{key}=", val) unless key == 'inhabitants'
      end

      result
    end
  end
end
