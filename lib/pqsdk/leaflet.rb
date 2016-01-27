module PQSDK
  class Leaflet
    attr_accessor :id, :name, :url, :start_date, :end_date, :pdf_data, :image_urls, :store_ids

    def initialize(params = {})
      params.each do |key, val|
        send("#{key}=", val)
      end

      self.image_urls ||= []
      self.store_ids ||= []
    end

    def self.find(url)
      res = RestLayer.get('v1/leaflets', { url: url }, 'Authorization' => "Bearer #{Token.access_token}")
      if res[0] == 200
        Leaflet.from_json res[1]
      elsif res[0] == 404
        nil
      else
        fail "Unexpected HTTP status code #{res[0]}"
      end
    end

    def show
      method = :get
      endpoint = 'v1/leaflet'
      expected_status = 201
      fields = {}
      fields['id'] = id unless id.is_a?(Integer) && !id.nil?

      res = RestLayer.send(method, endpoint, fields, 'Authorization' => "Bearer #{Token.access_token}")

      if res[0] != expected_status
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      end
    end

    def save
      method = :post
      endpoint = 'v1/leaflets'
      expected_status = 201

      fields = {}
      fields['name'] = name unless name.nil?
      fields['url'] = url unless url.nil?
      fields['start_date'] = start_date unless start_date.nil?
      fields['end_date'] = end_date unless end_date.nil?
      fields['pdf_data'] = pdf_data unless pdf_data.nil?
      fields['image_urls'] = image_urls.try(:to_json) || []
      fields['store_ids'] = store_ids.try(:to_json) || []

      res = RestLayer.send(method, endpoint, fields, 'Authorization' => "Bearer #{Token.access_token}")

      if res[0] != expected_status
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      elsif method == :post
        self.id = res[1]['id']
      end
    end

    def self.from_json(json)
      result = Leaflet.new

      json.each do |key, val|
        if result.respond_to?("#{key}=") && key != 'retailer' && key != 'url' && key != 'pages'
          result.send("#{key}=", val)
        elsif key == 'url' && result.respond_to?(:origin=)
          result.origin = val
        elsif key == 'retailer' && result.respond_to?(:retailer_id=)
          result.retailer_id = val['id']
        elsif key == 'pages' && result.respond_to?(:page)
          val.each do |page|
            result.page_ids << page['id']
          end
        end
      end

      result
    end
  end
end
