module PQSDK
  class Leaflet
    attr_accessor :id, :name, :url, :start_date, :end_date, :pdf_data, :image_urls

    def initialize
      self.image_urls = []
    end

    def self.find(url)
      res = RestLayer.get('v1/leaflets', { url: url }, { 'Authorization' => "Bearer #{Token.access_token}" })
      if res[0] == 200
        Leaflet.from_json res[1]
      elsif res[0] == 404
        nil
      else
        raise Exception.new("Unexpected HTTP status code #{res[0]}")
      end
    end

    def show
      method = :get
      endpoint = "v1/leaflet"
      expected_status = 201
      fields = {}
      fields['id'] = id unless id.is_a? Integer and !id.nil?

      res = RestLayer.send(method, endpoint, fields, {'Authorization' => "Bearer #{Token.access_token}"})

      if res[0] != expected_status
        raise Exception.new("Unexpected HTTP status code #{res[0]}")
      end
    end

    def save
      method = :post
      endpoint = "v1/leaflets"
      expected_status = 201

      fields = {}
      fields['name'] = name unless name.nil?
      fields['url'] = url unless url.nil?
      fields['start_date'] = start_date unless start_date.nil?
      fields['end_date'] = end_date unless end_date.nil?
      fields['pdf_data'] = pdf_data unless pdf_data.nil?
      fields['image_urls'] = image_urls.try(:to_json) || []

      res = RestLayer.send(method, endpoint, fields, {'Authorization' => "Bearer #{Token.access_token}"})

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
      result = Leaflet.new

      json.each do |key, val|
        if result.respond_to?("#{key}=") and key != 'retailer' and key != 'url' and key != 'pages'
          result.send("#{key}=", val)
        elsif key=="url" and result.respond_to?(:origin=)
          result.origin=val
        elsif key=="retailer" and result.respond_to?(:retailer_id=)
          result.retailer_id=val['id']
        elsif key=="pages" and result.respond_to?(:page)
          val.each do |page|
            result.page_ids << page['id']
          end
        end
      end

      result
    end
  end
end
