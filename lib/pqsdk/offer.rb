require 'pqsdk/remote_object'

module PQSDK
  # The Offer class provides an interface for crawlers to the v1/offers api
  # endpoint.
  class Offer < RemoteObject
    @endpoint = 'v1/offers'

    attr_accessor :id, :title, :description, :price, :original_price, :discount,
                  :start_date, :end_date, :brand, :image, :store_ids, :national,
                  :partner_link, :btn_other_offers_visible, :btn_partner_link_text,
                  :btn_partner_link_visible, :btn_print_visible, :btn_stores_visible,
                  :btn_online_offers_visible

    validates :title, :image, :store_ids, presence: true

    def attributes
      {
        'title' => nil, 'description' => nil, 'price' => nil, 'original_price' => nil,
        'discount' => nil, 'start_date' => nil, 'end_date' => nil, 'brand' => nil,
        'image' => nil, 'store_ids' => nil, 'national' => nil, 'partner_link' => nil,
        'btn_other_offers_visible' => nil, 'btn_partner_link_text' => nil,
        'btn_partner_link_visible' => nil, 'btn_print_visible' => nil,
        'btn_stores_visible' => nil, 'btn_online_offers_visible' => nil
      }
    end

    def store_ids
      @store_ids ||= []
    end

    def btn_other_offers_visible
      @btn_other_offers_visible ||= true
    end

    def btn_partner_link_visible
      @btn_partner_link_visible ||= true
    end

    def btn_print_visible
      @btn_print_visible ||= true
    end

    def btn_stores_visible
      @btn_stores_visible ||= true
    end

    def btn_online_offers_visible
      @btn_online_offers_visible ||= true
    end
  end
end
