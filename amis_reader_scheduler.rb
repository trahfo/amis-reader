require 'rufus-scheduler'
require_relative 'amis_reader_reader'

scheduler = Rufus::Scheduler.new
scheduler.every '1s' do
  AmisReaderReader.new.run
end
scheduler.join
