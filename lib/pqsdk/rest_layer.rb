module PQSDK
  class RestLayer
    def self.get(endpoint, parameters = {}, headers = {})
      conn = Faraday.new(Settings.api_root)

      res = conn.get endpoint, parameters, headers

      check_status(res.status.to_i, res.body)

      begin
        [ res.status.to_i, JSON.parse(res.body), res.headers ]
      rescue JSON::ParserError
        [ res.status.to_i, nil, res.headers ]
      end
    end

    def self.post(endpoint, parameters = {}, headers = {})
      conn = Faraday.new(Settings.api_root)

      if headers['Content-Type'] == 'application/json'
        res = conn.post endpoint, parameters.to_json, headers
      else
        res = conn.post endpoint, parameters, headers
      end

      check_status(res.status.to_i, res.body)

      begin
        [ res.status.to_i, JSON.parse(res.body), res.headers ]
      rescue JSON::ParserError
        [ res.status.to_i, nil, res.headers ]
      end
    end

    def self.put(endpoint, parameters = {}, headers = {})
      conn = Faraday.new(Settings.api_root)

      if headers['Content-Type'] == 'application/json'
        res = conn.put endpoint, parameters.to_json, headers
      else
        res = conn.put endpoint, parameters, headers
      end

      check_status(res.status.to_i, res.body)

      begin
        [ res.status.to_i, JSON.parse(res.body), res.headers ]
      rescue JSON::ParserError
        [ res.status.to_i, nil, res.headers ]
      end
    end

  private
    def self.check_status(code, body)
      if code >= 500
        raise Exception.new("Internal Server Error: " + body)
      elsif code == 401
        raise Exception.new("You are not authorized to perform that request")
      end
    end
  end
end
