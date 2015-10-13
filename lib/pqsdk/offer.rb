module PQSDK
  class Offer
    attr_accessor :title, :description, :price, :original_price, :discount, :start_date, :end_date, :image, :store_ids

    def initialize(params = {})
      params.each do |key, val|
        send("#{key}=", val)
      end

      store_ids ||= []
    end

    def save
      method = :post
      endpoint = "v1/offers"

      fields = {}
      [ :title, :description, :price, :original_price, :discount, :start_date, :end_date, :image ].each do |key|
        fields[key.to_s] = send(key) unless send(key).nil?
      end
      fields['store_ids'] = store_ids

      res = RestLayer.send(method, endpoint, fields, {'Authorization' => "Bearer #{Token.access_token}", 'Content-Type' => 'application/json'})

      if [200, 201].include? res[0]
        # All right!
      elsif res[0] == 400
        raise Exception.new("Bad request! Error: #{res[1]['errors']}")
      else
        raise Exception.new("Unexpected HTTP status code #{res[0]}")
      end
    end

    def to_hash
      {
        title: title,
        description: description,
        price: price,
        original_price: original_price,
        discount: discount,
        start_date: start_date,
        end_date: end_date,
        image: image,
        store_ids: store_ids
      }
    end
  end
end
