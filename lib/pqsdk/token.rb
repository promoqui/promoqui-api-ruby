module PQSDK
  class Token
    @access_token = nil
    @expiration = nil

    def self.get
      res = RestLayer.get('v1/token', {}, 'Authentication' => "Key #{Settings.app_secret}")

      if res[0] == 200
        @access_token = res[1]['token']
        @expiration = Time.parse(res[1]['expired_at'])
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

    def self.reset!
      @access_token = nil
      @expiration = nil
    end
  end
end
