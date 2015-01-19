module PQSDK
  class City
    attr_accessor :id, :name, :inhabitants, :latitude, :longitude

    def self.find(name)
      res = RestLayer.get('v1/cities', { q: name }, { 'Authorization' => "Bearer #{Token.access_token}" })
      if res[0] == 200
        City.from_json res[1]
      elsif res[0] == 404
        nil
      else
        raise Exception.new("Unexpected HTTP status code #{res[0]}")
      end
    end

    def self.find_or_create(name)
      city = self.find(name)
      return city if city

      city = City.new
      city.name = name
      city.save

      city
    end

    def save
      res = RestLayer.post('v1/cities', { name: name }, { 'Authorization' => "Bearer #{Token.access_token}" })

      if res[0] != 201
        raise Exception.new("Unexpected HTTP status code #{res[0]}")
      else
        json = JSON.parse(res[1])
        self.id = json['id']
      end
    end

  private
    def self.from_json(json)
      result = City.new

      json.each do |key, val|
        result.send("#{key}=", val)
      end

      result
    end
  end
end
