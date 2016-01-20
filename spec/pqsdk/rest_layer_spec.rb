describe PQSDK::RestLayer do
  before do
    PQSDK::Settings.host = 'www.example.com'
  end

  describe '.get' do
    it 'launches a get request on the settings domain and given path' do
      stub = stub_request(:get, "www.example.com/api.json")
                          .to_return(body: '{}')

      PQSDK::RestLayer.get('api.json')

      expect(stub).to have_been_requested
    end

    it 'sets request parameters' do
      stub = stub_request(:get, "www.example.com/api.json")
                          .with(query: { a: 1, b: 'hello' })
                          .to_return(body: '{}')

      PQSDK::RestLayer.get('api.json', { b: 'hello', a: 1 })

      expect(stub).to have_been_requested
    end

    it 'sets request headers' do
      stub = stub_request(:get, "www.example.com/api.json")
                          .with(headers: { 'Accept' => 'application/json' })
                          .to_return(body: '{}')

      PQSDK::RestLayer.get('api.json', {}, { 'Accept' => 'application/json' })

      expect(stub).to have_been_requested
    end

    it 'returns an array with the status code as the first element' do
      stub = stub_request(:get, "www.example.com/api.json")
                          .to_return(body: '{}', status: 203)

      response = PQSDK::RestLayer.get('api.json')
      expect(response[0]).to eq 203
    end

    it 'returns an array with the parsed json body as second element' do
      stub = stub_request(:get, "www.example.com/api.json")
                          .to_return(body: '{"hello": "world"}')

      response = PQSDK::RestLayer.get('api.json')
      expect(response[1]).to eq({ 'hello' => 'world' })
    end

    it 'returns an array with nil as second element when the body is not valid json' do
      stub = stub_request(:get, "www.example.com/api.json")
                          .to_return(body: 'fake random data')

      response = PQSDK::RestLayer.get('api.json')
      expect(response[1]).to be_nil
    end

    it 'returns an array with the normalized response headers as the third element' do
      stub = stub_request(:get, "www.example.com/api.json")
                          .to_return(body: '{}', headers: { 'X-Location' =>  'Rome' })

      response = PQSDK::RestLayer.get('api.json')
      expect(response[2]).to eq({ 'x-location' => [ 'Rome' ] })
    end
  end
end
