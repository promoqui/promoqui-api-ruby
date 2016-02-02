describe PQSDK::Leaflet do
  it { is_expected.to have_field(:id) }
  it { is_expected.to have_field(:name) }
  it { is_expected.to have_field(:url) }
  it { is_expected.to have_field(:start_date) }
  it { is_expected.to have_field(:end_date) }
  it { is_expected.to have_field(:pdf_data) }
  it { is_expected.to have_field(:image_urls) }
  it { is_expected.to have_field(:store_ids) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  it 'defaults store_ids to an empty array' do
    l = PQSDK::Leaflet.new
    expect(l.store_ids).to eq []
  end

  it 'defaults image_urls to an empty array' do
    l = PQSDK::Leaflet.new
    expect(l.image_urls).to eq []
  end

  it 'base64 encodes pdf_data' do
    l = PQSDK::Leaflet.new(name: 'Test', url: 'http://www.google.com', pdf_data: 'raw pdf data')
    expect(l.serializable_hash['pdf_data']).to eq "cmF3IHBkZiBkYXRh\n"
  end

  describe '#find' do
    before do
      allow(PQSDK::Token).to receive(:retailer_id).and_return 123
    end

    it 'GETs the index action with the url and retailer_id parameters' do
      expect(PQSDK::RestLayer).to receive(:get).with('v1/leaflets', url: 'fake', retailer_id: 123).and_return([200, {}, {}])
      PQSDK::Leaflet.find('fake')
    end

    it 'returns a Leaflet object with the fields filled' do
      allow(PQSDK::RestLayer).to receive(:get).and_return([200, { name: 'test' }, {}])
      result = PQSDK::Leaflet.find('fake')

      expect(result).to be_a PQSDK::Leaflet
      expect(result.name).to eq 'test'
    end

    it 'returns nil if the leaflet is not found' do
      allow(PQSDK::RestLayer).to receive(:get).and_return([404, {}, {}])
      result = PQSDK::Leaflet.find('fake')

      expect(result).to be_nil
    end
  end
end
