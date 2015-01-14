module PQSDK
  class Settings
    @@host = nil
    @@app_secret = nil

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
  end
end
