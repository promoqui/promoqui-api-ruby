describe PQSDK::Store do
  it { is_expected.to have_read_only_field(:id) }
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

  describe '#initialize' do
    it 'accepts a list of params' do
      s = PQSDK::Store.new(name: 'Fake', address: 'Fake Street, 3')

      expect(s.name).to eq 'Fake'
      expect(s.address).to eq 'Fake Street, 3'
    end

    it 'ignores id param' do
      s = PQSDK::Store.new(id: 123)
      expect(s.id).to be_nil
    end

    it 'ignores unknown params' do
      expect {
        PQSDK::Store.new(fake: 'param')
      }.to_not raise_error
    end

    it 'defaults opening_hours to an empty array' do
      s = PQSDK::Store.new
      expect(s.opening_hours).to eq []
    end
  end
end
