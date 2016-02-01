module PQSDK
  # The Token holds the random access token generated on every crawler run,
  # and it is used to authenticate all following requests.
  class Token
    @access_token = nil
    @expiration = nil
    @retailer_id = nil

    def self.get
      res = RestLayer.get('v1/token', {}, 'Authentication' => "Key #{Settings.app_secret}")

      if res[0] == 200
        @access_token = res[1]['token']
        @expiration = Time.parse(res[1]['expired_at'])
        @retailer_id = res[1]['retailer_id']
      end

      @access_token
    end

    def self.access_token
      if @access_token.nil? || @expiration <= Time.now
        get
      else
        @access_token
      end
    end

    def self.retailer_id
      get unless @retailer_id

      @retailer_id
    end

    def self.reset!
      @access_token = nil
      @expiration = nil
      @retailer_id = nil
    end
  end
end
