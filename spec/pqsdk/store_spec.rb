describe PQSDK::Store do
  it { is_expected.to have_field(:id) }
  it { is_expected.to have_field(:name) }
  it { is_expected.to have_field(:city) }
  it { is_expected.to have_field(:address) }
  it { is_expected.to have_field(:zipcode) }
  it { is_expected.to have_field(:latitude) }
  it { is_expected.to have_field(:longitude) }
  it { is_expected.to have_field(:phone) }
  it { is_expected.to have_field(:city_id) }
  it { is_expected.to have_field(:origin) }
  it { is_expected.to have_field(:opening_hours) }
  it { is_expected.to have_field(:opening_hours_text) }

  it { is_expected.to validate_presence_of :origin }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :address }
  it { is_expected.to validate_presence_of :latitude }
  it { is_expected.to validate_presence_of :longitude }

  context 'when city is nil' do
    subject { PQSDK::Store.new(city: nil) }
    it { is_expected.to validate_presence_of :city_id }
  end

  context 'when city is not nil' do
    subject { PQSDK::Store.new(city: 'Gotham') }
    it { is_expected.to_not validate_presence_of :city_id }
  end

  it 'defaults opening_hours to an empty array' do
    s = PQSDK::Store.new
    expect(s.opening_hours).to eq []
  end

  describe '#to_json' do
    it 'ignores the city value' do
      s = PQSDK::Store.from_hash('id' => 1, 'name' => 'Fake', 'city' => 'Whatever')
      expect(s.name).to eq 'Fake'
      expect(s.city).to be_nil
    end
  end
end
