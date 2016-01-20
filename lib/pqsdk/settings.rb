module PQSDK
  class Settings
    class << self
      attr_accessor :host, :app_secret, :schema

      def schema
        @schema ||= 'http'
      end
    end

    def self.api_root
      "#{schema}://#{host}"
    end
  end
end
