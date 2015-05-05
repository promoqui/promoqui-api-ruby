module PQSDK
  class Settings
    @@host = nil
    @@app_secret = nil
    @@schema = 'http'

    def self.host
      @@host
    end

    def self.host=(val)
      @@host = val
    end

    def self.app_secret
      @@app_secret
    end

    def self.app_secret=(val)
      @@app_secret = val
    end

    def self.schema
      @@schema
    end

    def self.schema=(val)
      @@schema = val
    end
  end
end
