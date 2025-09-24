require 'net/http'
require 'json'
require 'csv'
require 'fileutils'

# AmisReader fetches data from a specified URL,
# processes it, and appends it to a CSV file.
class AmisReader
  URL = 'http://10.0.0.99/rest'.freeze

  def initialize()
    @bezug0 = -1.0            # wird um 23:59:59 oder 00:00:00 gesetzt, sonst -1.0 = unbekannt
    @speisung0 = -1.0         # wird um 23:59:59 oder 00:00:00 gesetzt, sonst -1.0 = unbekannt
    data = fetch_json_from_url()
    @timestamp = data['time']
    @current_date = Time.at(@timestamp).utc.to_date
    @filename = build_filename(@current_date)
    puts "File name: #{@filename}"

    if !File.exist?(@filename)
      write_header()
    end

    # write the current found time without any other data to create a gap
    f = File.open(@filename, mode="a+")
    f.puts "#{Time.at(@timestamp).utc.strftime("%T")};;;;;;;"            # make sure tracking starts with a gap
    f.close()
  end

  def write_header()
    CSV.open(@filename, 'a', col_sep:';') do |csv|
      # write header if it's the first row of the day
      csv << AMIS_STRUCT.keys
    end
  end

  AMIS_STRUCT = {
    'Zeit' => 'time',         # Zeitstempel
    'Bezug' => '1.8.0',       # Zählerstand bezogen
    'Speisung' => '2.8.0',    # Zählerstand eingespeist
    'Verbrauch' => '1.7.0',   # Momentanverbrauch 
    'Einspeisung' => '2.7.0', # Momentaneinspeisung
    'Saldo' => 'saldo',       # Saldo
    'Tagesbezug' => 'Tagessbezug',	       # optional berechnet
    'Tagesspeisung' => 'Tagesspeisung'     # optional berechnet
  }.freeze

  def run(url = URL)
    data = fetch_json_from_url(url)
    if data['time'] != @timestamp
      @timestamp = data['time']
      date = Time.at(@timestamp).utc.to_date

      if date != @current_date
        puts "Date changed from #{@current_date} to #{date}"
        @filename = build_filename(date)
        @current_date = date
        write_header()
        if Time.at(@timestamp).utc.strftime('%T') > '00:00:05'
          @bezug0 = -1.0
          @speisung0 = -1.0
        else
          @bezug0 = data[AMIS_STRUCT['Bezug']] / 1000.0
          @speisung0 = data[AMIS_STRUCT['Speisung']] / 1000.0
        end
        puts "New day detected. File name: #{@filename}, bezug0: #{@bezug0}, speisung0: #{@speisung0}"
      end

      values = transform_data(data)
      append_values_to_csv(values)
    end
  end

  def fetch_json_from_url(url=URL)
    JSON.parse(Net::HTTP.get(URI(url)))
  rescue StandardError => e
    puts "Error fetching or parsing JSON: #{e.message}"
    {}
  end

  def build_filename(date)
    "C:/so/strom/#{date}.csv"
  end

  def transform_data(data)
    values = []
    values << Time.at(@timestamp).utc.strftime('%T')
    if values[0] == '00:00:00'
      @bezug0 = data[AMIS_STRUCT['Bezug']] / 1000
      @speisung0 = data[AMIS_STRUCT['Speisung']] / 1000
    end

    values << data[AMIS_STRUCT['Bezug']] / 1000.0
    values << data[AMIS_STRUCT['Speisung']] / 1000.0
    values << data[AMIS_STRUCT['Verbrauch']] / 1000.0
    values << data[AMIS_STRUCT['Einspeisung']] / -1000.0
    values << data[AMIS_STRUCT['Saldo']] / 1000.0
    if @bezug0 >= 0.0 && @speisung0 >= 0.0
      values << (data[AMIS_STRUCT['Bezug']] / 1000.0 - @bezug0)
      values << (data[AMIS_STRUCT['Speisung']]  / 1000.0 - @speisung0)
    else
      values << nil
      values << nil
    end

    print "\r#{values[0]}"
    for i in 1..5
      sz = format("%.3f",values[i])
      print "  #{sz}"
    end

    if values[0] == '23:59:59'
      @bezug0 = values[1]
      @speisung0 = values[2]
    end

    values     # Rückgabe der Werte
  end

  def append_values_to_csv(values)
    CSV.open(@filename, 'a', col_sep:';') do |csv|
      # write the values
      csv << values
    end

  rescue StandardError => e
    puts "Error writing to CSV: #{e.message}"
  end
end
