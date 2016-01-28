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
