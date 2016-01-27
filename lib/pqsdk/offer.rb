module PQSDK
  class Offer
    attr_accessor :title, :description, :price, :original_price, :discount, :start_date, :end_date, :brand, :image, :store_ids, :national, :partner_link,
                  :btn_other_offers_visible, :btn_partner_link_text, :btn_partner_link_visible, :btn_print_visible, :btn_stores_visible, :btn_online_offers_visible

    def initialize(params = {})
      params.each do |key, val|
        send("#{key}=", val)
      end
    end

    def save
      method = :post
      endpoint = 'v1/offers'

      fields = { offer: {} }
      [:title, :description, :price, :original_price, :discount, :start_date, :end_date, :brand, :image,
       :national, :partner_link, :btn_other_offers_visible, :btn_partner_link_text,
       :btn_partner_link_visible, :btn_print_visible, :btn_stores_visible, :btn_online_offers_visible].each do |key|
        fields[:offer][key.to_s] = send(key) unless send(key).nil?
      end
      fields[:offer]['store_ids'] = store_ids.presence || []

      res = RestLayer.send(method, endpoint, fields, 'Authorization' => "Bearer #{Token.access_token}", 'Content-Type' => 'application/json')

      if [200, 201].include? res[0]
        # All right!
      elsif res[0] == 400
        fail "Bad request! Error: #{res[1]['errors']}"
      else
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
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
        brand: brand,
        image: image,
        store_ids: store_ids
      }
    end
  end
end
