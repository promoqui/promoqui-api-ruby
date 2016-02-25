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

    validates :title, :image, presence: true
    validates :store_ids, presence: true unless national?

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

    def national
      @national ||= false
    end

    def national?
      national
    end

    def store_ids
      @store_ids ||= []
    end

    def btn_other_offers_visible
      if @btn_other_offers_visible.nil?
        @btn_other_offers_visible = true
      else
        @btn_other_offers_visible
      end
    end

    def btn_partner_link_visible
      if @btn_partner_link_visible.nil?
        @btn_partner_link_visible = true
      else
        @btn_partner_link_visible
      end
    end

    def btn_print_visible
      if @btn_print_visible.nil?
        @btn_print_visible = true
      else
        @btn_print_visible
      end
    end

    def btn_stores_visible
      if @btn_stores_visible.nil?
        @btn_stores_visible = true
      else
        @btn_stores_visible
      end
    end

    def btn_online_offers_visible
      if @btn_online_offers_visible.nil?
        @btn_online_offers_visible = true
      else
        @btn_online_offers_visible
      end
    end
  end
end
