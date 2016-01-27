require 'active_support'
require 'active_model'

module PQSDK
  # The RemoteObject class is an abstraction for common API utilities like .get
  # and #save.
  class RemoteObject
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    def self.get(id)
      res = RestLayer.get("#{@endpoint}/#{id}")
      if res[0] == 200
        from_json res[1]
      elsif res[0] == 404
        nil
      else
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
      end
    end

    def save
      if valid?
        persisted? ? update! : create!
      else
        false
      end
    end

    def create
      res = RestLayer.post(@endpoint, serialized_hash, 'Authorization' => "Bearer #{Token.access_token}", 'Content-Type' => 'application/json')
      if [201, 202].include? res[0]
        self.id = res[1]['id']
        true
      else
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
        # false
      end
    end

    def update
      res = RestLayer.put("#{@endpoint}/#{id}", serialized_hash, 'Authorization' => "Bearer #{Token.access_token}", 'Content-Type' => 'application/json')
      if res[0] == 200
        true
      else
        fail "Unexpected HTTP status code #{res[0]}, #{res[1]}"
        # false
      end
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