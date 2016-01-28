describe PQSDK::Offer do
  it { is_expected.to have_field(:id) }
  it { is_expected.to have_field(:title) }
  it { is_expected.to have_field(:description) }
  it { is_expected.to have_field(:price) }
  it { is_expected.to have_field(:original_price) }
  it { is_expected.to have_field(:discount) }
  it { is_expected.to have_field(:start_date) }
  it { is_expected.to have_field(:end_date) }
  it { is_expected.to have_field(:brand) }
  it { is_expected.to have_field(:image) }
  it { is_expected.to have_field(:store_ids) }
  it { is_expected.to have_field(:national) }
  it { is_expected.to have_field(:partner_link) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :image }
  it { is_expected.to validate_presence_of :store_ids }

  it 'defaults store_ids to an empty array' do
    s = PQSDK::Offer.new
    expect(s.store_ids).to eq []
  end
end
