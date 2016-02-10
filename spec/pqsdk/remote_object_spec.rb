class FakeObject < PQSDK::RemoteObject
  @endpoint = 'v1/fakes'

  attr_accessor :id, :name

  def attributes
    { 'name' => nil }
  end
end

describe PQSDK::RemoteObject do
  describe '#initialize' do
    it 'accepts a list of params' do
      s = FakeObject.new(name: 'Fake')

      expect(s.name).to eq 'Fake'
    end

    it 'raises when an invalid param is given' do
      expect { FakeObject.new(address: 'Fake Address') }.to raise_error(NoMethodError)
    end
  end

  describe '.get' do
    it 'gets the stores/:id endpoint with a get request' do
      expect(PQSDK::RestLayer).to receive(:get)
        .with('v1/fakes/123')
        .and_return([200, {}, {}])
      FakeObject.get(123)
    end

    context 'when the response is successful' do
      it 'returns a PQSDK::Store object' do
        allow(PQSDK::RestLayer).to receive(:get)
          .and_return([200, {}, {}])
        res = FakeObject.get(123)
        expect(res).to be_a(FakeObject)
      end

      it 'stores the returned values' do
        allow(PQSDK::RestLayer).to receive(:get)
          .and_return([200, { id: 123, name: 'Fake' }, {}])
        res = FakeObject.get(123)
        expect(res.id).to eq 123
        expect(res.name).to eq 'Fake'
      end

      it 'ignores unknown attributes' do
        allow(PQSDK::RestLayer).to receive(:get)
          .and_return([200, { id: 123, bad: 'Fake' }, {}])
        expect { FakeObject.get(123) }.to_not raise_error
      end
    end

    context 'when the response is not found' do
      it 'returns nil' do
        allow(PQSDK::RestLayer).to receive(:get)
          .and_return([404, nil, {}])
        expect(FakeObject.get(123)).to be_nil
      end
    end
  end

  describe '#save' do
    before { allow(PQSDK::Token).to receive(:access_token).and_return 123 }

    it 'returns false when the object is not valid' do
      s = FakeObject.new(name: 'Fake')
      allow(s).to receive(:valid?).and_return false

      expect(s.save).to be_falsey
    end

    it 'returns true if the object gets saved' do
      allow(PQSDK::RestLayer).to receive(:post)
        .and_return([201, { 'id' => 1 }, {}])

      s = FakeObject.new(name: 'Fake')
      expect(s.save).to be_truthy
    end

    context 'when the object is persisted' do
      let(:o) { FakeObject.new(id: 1, name: 'Fake') }

      it 'sends a put request to the object' do
        expect(PQSDK::RestLayer).to receive(:put)
          .with(%r{v\d+/fakes/1$}, { 'name' => 'Fake' }, 'Authorization' => 'Bearer 123')
          .and_return([200, {}, {}])
        o.save
      end

      it 'raises an error if the response is not 200' do
        allow(PQSDK::RestLayer).to receive(:put)
          .and_return([400, {}, {}])
        expect { o.save }.to raise_error(RuntimeError)
      end
    end

    context 'when the object is not persisted' do
      let(:o) { FakeObject.new(name: 'Fake') }

      it 'sends a post request to the collection' do
        expect(PQSDK::RestLayer).to receive(:post)
          .with(%r{v\d+/fakes$}, { 'name' => 'Fake' }, 'Authorization' => 'Bearer 123')
          .and_return([201, {}, {}])
        o.save
      end

      it 'raises an error if the response is not 201 or 202' do
        allow(PQSDK::RestLayer).to receive(:post)
          .and_return([400, {}, {}])
        expect { o.save }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#to_json' do
    it 'returns a JSON serialization of the object' do
      s = FakeObject.new(name: 'Fake')
      expect(JSON.parse(s.to_json)['name']).to eq 'Fake'
    end
  end

  describe '#persisted?' do
    it 'is true when the id is defined' do
      expect(FakeObject.new(id: 1)).to be_persisted
    end

    it 'is false when the id is nil' do
      expect(FakeObject.new).to_not be_persisted
    end
  end
end
