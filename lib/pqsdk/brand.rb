module PQSDK
  class Brand
    attr_accessor :id, :name, :slug

    def self.list
      res = RestLayer.get('v1/brands', {}, { 'Authorization' => "Bearer #{Token.access_token}" })
      if res[0] == 200
        res[1].map{|brand| Brand.from_json(brand)}
      elsif res[0] == 404
        nil
      else
        raise Exception.new("Unexpected HTTP status code #{res[0]}")
      end
    end

    def self.find(name)
      res = RestLayer.get('v1/brands/search', { q: name }, { 'Authorization' => "Bearer #{Token.access_token}" })
      if res[0] == 200
        Brand.from_json res[1]
      elsif res[0] == 404
        nil
      else
        raise Exception.new("Unexpected HTTP status code #{res[0]}")
      end
    end

    private
    def self.from_json(json)
      result = Brand.new

      json.each do |key, val|
        result.send("#{key}=", val)
      end

      result
    end
  end
end
