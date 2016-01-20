module PQSDK
  class RestLayer

    def self.get(endpoint, parameters = {}, headers = {})
      conn = Faraday.new("#{Settings.schema}://#{Settings.host}")

      res = conn.get endpoint, parameters, headers

      check_status(res.status.to_i, res.body)

      begin
        [ res.status.to_i, JSON.parse(res.body), res.headers ]
      rescue JSON::ParserError
        [ res.status.to_i, nil, res.headers ]
      end
    end

    def self.post(endpoint, parameters, headers)
      url = URI.parse("#{Settings.schema}://#{Settings.host}/#{endpoint}")
      req = Net::HTTP::Post.new(url.request_uri)

      if headers['Content-Type'] == 'application/json'
        req.body = parameters.to_json
      else
        req.set_form_data(parameters)
      end

      headers.each do |name, value|
        req[name.to_s] = value
      end

      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end

      check_status(res.code.to_i, res.body)
      if res.body and res.body.length > 1
        [ res.code.to_i, JSON.parse(res.body), res.to_hash ]
      else
        [ res.code.to_i, {}, res.to_hash ]
      end
    end

    def self.put(endpoint, parameters, headers)
      url = URI.parse("#{Settings.schema}://#{Settings.host}/#{endpoint}")
      req = Net::HTTP::Put.new(url.request_uri)

      if headers['Content-Type'] == 'application/json'
        req.body = parameters.to_json
      else
        req.set_form_data(parameters)
      end

      headers.each do |name, value|
        req[name.to_s] = value
      end

      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end

      check_status(res.code.to_i, res.body)
      [ res.code.to_i, JSON.parse(res.body), res.to_hash ]
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
