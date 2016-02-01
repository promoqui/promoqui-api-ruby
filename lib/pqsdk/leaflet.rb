require 'base64'
require 'pqsdk/remote_object'

module PQSDK
  # The Leaflet class provides an interface for crawlers to the v1/leaflets api
  # endpoint.
  class Leaflet < RemoteObject
    @endpoint = 'v1/leaflets'

    attr_accessor :id, :name, :url, :start_date, :end_date, :pdf_data,
                  :image_urls, :store_ids

    validates :name, :url, presence: true

    def attributes
      {
        'name' => nil, 'url' => nil, 'start_date' => nil, 'end_date' => nil,
        'pdf_data' => nil, 'image_urls' => nil, 'store_ids' => nil
      }
    end

    def self.find(url)
      res = RestLayer.get(@endpoint, url: url)

      return nil if res[0] == 404
      fail "Unexpected HTTP status code #{res[0]}" unless res[0] == 200

      from_hash res[1]
    end

    def image_urls
      @image_urls ||= []
    end

    def store_ids
      @store_ids ||= []
    end

    def pdf_data=(data)
      @pdf_data = Base64.encode64(data)
    end
  end
end
