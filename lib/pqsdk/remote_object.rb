require 'active_support'
require 'active_model'

module PQSDK
  # The RemoteObject class is an abstraction for common API utilities like .get
  # and #save.
  class RemoteObject
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    class << self
      attr_reader :endpoint
    end

    def self.all
      res = RestLayer.get(@endpoint)
      if res[0] == 200
        res[1].map { |entry| from_hash(entry) }
      else
        raise "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      end
    end

    def self.get(id)
      res = RestLayer.get("#{@endpoint}/#{id}")
      if res[0] == 200
        from_hash res[1]
      elsif res[0] == 404
        nil
      else
        raise "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      end
    end

    def self.from_hash(json)
      result = new
      json.each do |k, v|
        result.send("#{k}=", v) if result.respond_to?("#{k}=")
      end

      result
    end

    def save
      if valid?
        persisted? ? update! : create!
      else
        false
      end
    end

    def create
      res = RestLayer.post(self.class.endpoint, serializable_hash, 'Authorization' => "Bearer #{Token.access_token}")
      if [201, 202].include? res[0]
        self.id = res[1]['id']
        true
      else
        raise "Unexpected HTTP status code #{res[0]}, #{res[1]}"
        # false
      end
    end

    def update
      res = RestLayer.put("#{self.class.endpoint}/#{id}", serializable_hash, 'Authorization' => "Bearer #{Token.access_token}")
      if res[0] == 200
        true
      else
        raise "Unexpected HTTP status code #{res[0]}, #{res[1]}"
        # false
      end
    end

    def save!
      save || raise('Save failed')
    end

    def create!
      create
    end

    def update!
      update
    end

    def persisted?
      !id.nil?
    end
  end
end
