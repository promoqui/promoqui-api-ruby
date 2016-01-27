module PQSDK
  # A small wrapper to the Faraday gem to make get/post/put requests to the API
  # server.
  class RestLayer
    def self.get(endpoint, parameters = {}, headers = {})
      res = connection.get endpoint, parameters, headers

      check_result(res)

      begin
        [res.status.to_i, JSON.parse(res.body), res.headers]
      rescue JSON::ParserError
        [res.status.to_i, nil, res.headers]
      end
    end

    def self.post(endpoint, parameters = {}, headers = {})
      parameters = parameters.to_json if headers['Content-Type'] == 'application/json'
      res = connection.post endpoint, parameters, headers

      check_result(res)

      begin
        [res.status.to_i, JSON.parse(res.body), res.headers]
      rescue JSON::ParserError
        [res.status.to_i, nil, res.headers]
      end
    end

    def self.put(endpoint, parameters = {}, headers = {})
      parameters = parameters.to_json if headers['Content-Type'] == 'application/json'
      res = connection.put endpoint, parameters, headers

      check_result(res)

      begin
        [res.status.to_i, JSON.parse(res.body), res.headers]
      rescue JSON::ParserError
        [res.status.to_i, nil, res.headers]
      end
    end

    def self.connection
      Faraday.new(Settings.api_root)
    end

    def self.check_result(result)
      if result.status.to_i >= 500
        fail "Internal Server Error: #{result.body}"
      elsif result.status.to_i == 401
        fail 'You are not authorized to perform that request'
      end
    end
  end
end
