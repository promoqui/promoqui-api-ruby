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
end
