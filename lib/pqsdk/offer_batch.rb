module PQSDK
  class OfferBatch
    attr_accessor :offers

    def initialize
      @offers = []
    end

    def <<(offer)
      @offers << offer
    end

    def save
      request = []
      method = :post
      endpoint = "v1/offers"

      @offers.each do |offer|
        request << offer.to_hash
      end

      res = RestLayer.send(method, endpoint, request, {'Authorization' => "Bearer #{Token.access_token}", 'Content-Type' => 'application/json'})

      if res[0] == 200
        # All right!
      elsif res[0] == 400
        raise Exception.new("Bad request! Error: #{res[1]['errors']}")
      else
        raise Exception.new("Unexpected HTTP status code #{res[0]}")
      end
    end
  end
end
