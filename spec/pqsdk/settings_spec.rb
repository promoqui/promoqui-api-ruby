describe PQSDK::Settings do
  it 'stores the schema' do
    PQSDK::Settings.schema = 'mail'
    expect(PQSDK::Settings.schema).to eq 'mail'
  end

  it 'stores the host' do
    PQSDK::Settings.host = 'www.example.com'
    expect(PQSDK::Settings.host).to eq 'www.example.com'
  end

  it 'stores the app_secret' do
    PQSDK::Settings.app_secret = 's3cr3t'
    expect(PQSDK::Settings.app_secret).to eq 's3cr3t'
  end

  it 'defaults the schema to http' do
    PQSDK::Settings.schema = nil
    expect(PQSDK::Settings.schema).to eq 'http'
  end

  describe '.api_root' do
    it 'returns the schema and the hostname as an URI' do
      PQSDK::Settings.schema = 'https'
      PQSDK::Settings.host = 'www.example.com'

      expect(PQSDK::Settings.api_root).to eq 'https://www.example.com'
    end
  end
end
