module PQSDK
  class RestLayer
    def self.get(endpoint, parameters, headers)
      url = URI.parse("#{Settings.schema}://#{Settings.host}/#{endpoint}")
      url.query = URI.encode_www_form(parameters)
      req = Net::HTTP::Get.new(url.request_uri)

      headers.each do |name, value|
        req[name.to_s] = value
      end

      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end

      check_status(res.code.to_i, res.body)

      [ res.code.to_i, JSON.parse(res.body), res.to_hash ]
    end

    def self.post(endpoint, parameters, headers)
      url = URI.parse("#{Settings.schema}://#{Settings.host}/#{endpoint}")
      req = Net::HTTP::Post.new(url.request_uri)
      req.set_form_data(parameters)

      headers.each do |name, value|
        req[name.to_s] = value
      end

      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end

      check_status(res.code.to_i, res.body)
      [ res.code.to_i, JSON.parse(res.body), res.to_hash ]
    end

    def self.put(endpoint, parameters, headers)
      url = URI.parse("#{Settings.schema}://#{Settings.host}/#{endpoint}")
      req = Net::HTTP::Put.new(url.request_uri)
      req.set_form_data(parameters)

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
        raise Exception.new("Internal Server Error")
      elsif code == 400
        raise Exception.new("Bad Request. This usually imples a bug in this gem! Error: #{JSON.parse(body)['error']}")
      elsif code == 401
        raise Exception.new("You are not authorized to perform that request")
      end
    end
  end
end
