module PQSDK
  # A small wrapper to the Faraday gem to make get/post/put requests to the API
  # server.
  class RestLayer
    def self.get(endpoint, parameters = {}, headers = {})
      res = connection.get endpoint, parameters, headers

      check_result(res)
    end

    def self.post(endpoint, parameters = {}, headers = {})
      res = connection.post endpoint, parameters.to_json, headers.merge('Content-Type' => 'application/json')

      check_result(res)
    end

    def self.put(endpoint, parameters = {}, headers = {})
      res = connection.put endpoint, parameters.to_json, headers.merge('Content-Type' => 'application/json')

      check_result(res)
    end

    def self.connection
      Faraday.new(Settings.api_root)
    end

    def self.check_result(result)
      status = result.status.to_i
      headers = result.headers
      fail "Internal Server Error: #{result.body}" if status >= 500
      fail 'You are not authorized to perform that request' if status == 401

      begin
        [status, JSON.parse(result.body), headers]
      rescue JSON::ParserError
        [status, nil, headers]
      end
    end
  end
end
