require 'net/http'
require 'json'
require 'csv'

# AmisReader fetches data from a specified URL,
# processes it, and appends it to a CSV file.
class AmisReader
  URL = 'http://10.0.0.99/rest'.freeze

  AMIS_STRUCT = {
    'Zeit' => 'time',        # Zeitstempel
    'Bezogen' => '1.8.0',    # Zählerstand bezogen
    'Eingespeist' => '2.8.0' # Zählerstand eingespeist
  }.freeze

  def run(url = URL)
    data = fetch_json_from_url(url)
    date = Time.at(data[AMIS_STRUCT['Zeit']]).utc.to_date
    filename = build_filename(date)
    values = transform_data(data)
    append_values_to_csv(filename, values)
  end

  def fetch_json_from_url(url=URL)
    JSON.parse(Net::HTTP.get(URI(url)))
  rescue StandardError => e
    puts "Error fetching or parsing JSON: #{e.message}"
    {}
  end

  def build_filename(date)
    "amis_reader_#{date.strftime('%Y-%m-%d')}.csv"
  end

  def transform_data(data)
    values = []
    values << Time.at(data['time']).utc.strftime('%Y-%m-%d %H:%M:%S')
    values << data[AMIS_STRUCT['Bezogen']] / 1000.0
    values << data[AMIS_STRUCT['Eingespeist']] / 1000.0
    values
  end

  def append_values_to_csv(file_path, values)
    first_row_of_day = !File.exist?(file_path)

    CSV.open(file_path, 'a', col_sep:';') do |csv|
      # write header if it's the first row of the day
      csv << AMIS_STRUCT.keys if first_row_of_day
      # write the values
      csv << values
    end

  rescue StandardError => e
    puts "Error writing to CSV: #{e.message}"
  end
end
