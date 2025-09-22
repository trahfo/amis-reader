require 'rufus-scheduler'
require_relative 'amis_reader'

scheduler = Rufus::Scheduler.new
scheduler.every '1s' do
  AmisReader.new.run
end
scheduler.join
