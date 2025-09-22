require_relative 'spec_helper'
require_relative '../src/amis_reader'

describe AmisReader do
  let(:reader) { AmisReader.new }
  let(:url) { 'http://example.com' }
  let(:json_response) do
    '{ "time": 1678886400, "1.8.0": 12345.6, "2.8.0": 6789.0 }'
  end
  let(:data) { JSON.parse(json_response) }
  let(:date) { Time.at(data['time']).utc.to_date }
  let(:filename) { "amis_reader_#{date.strftime('%Y-%m-%d')}.csv" }
  let(:values) { ["2023-03-15 13:20:00", 12.345600000000001, 6.789] }

  before do
    allow(Net::HTTP).to receive(:get).with(URI(url)).and_return(json_response)
    allow(CSV).to receive(:open).with(any_args)
  end

  describe '#run' do
    it 'fetches JSON, transforms it, and appends it to a CSV' do
      expect(reader).to receive(:fetch_json_from_url).with(url).and_return(data)
      expect(reader).to receive(:transform_data).with(data).and_return(values)
      expect(reader).to receive(:append_values_to_csv).with(filename, values)
      reader.run(url)
    end
  end

  describe '#fetch_json_from_url' do
    it 'returns a parsed JSON object' do
      expect(reader.fetch_json_from_url(url)).to eq(data)
    end

    it 'handles errors and returns an empty hash' do
      allow(Net::HTTP).to receive(:get).with(URI(url)).and_raise(StandardError)
      expect(reader.fetch_json_from_url(url)).to eq({})
    end
  end

  describe '#build_filename' do
    it 'returns a correctly formatted filename' do
      expect(reader.build_filename(date)).to eq(filename)
    end
  end

  describe '#transform_data' do
    it 'transforms the data correctly' do
      expect(reader.transform_data(data)).to eq(values)
    end
  end

  describe '#append_values_to_csv' do
    it 'appends values to a CSV file' do
      expect(CSV).to receive(:open).with(filename, 'a')
      reader.append_values_to_csv(filename, values)
    end

    it 'creates a new file with headers if it does not exist' do
      allow(File).to receive(:exist?).with(filename).and_return(false)
      expect(CSV).to receive(:open).with(filename, 'w')
      expect(CSV).to receive(:open).with(filename, 'a')
      reader.append_values_to_csv(filename, values)
    end
  end
end
