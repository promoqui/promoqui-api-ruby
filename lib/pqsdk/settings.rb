module PQSDK
  # The Settings class contains the configuration for the library.
  class Settings
    class << self
      attr_accessor :host, :app_secret, :schema

      def schema
        @schema ||= 'https'
      end

      def app_secret=(secret)
        Token.reset!
        @app_secret = secret
      end
    end

    def self.api_root
      "#{schema}://#{host}"
    end
  end
end
