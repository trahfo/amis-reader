ENV['TZ'] = 'Europe/Vienna'
require 'rufus-scheduler'
require './src/amis_reader'

begin
  amis=AmisReader.new
  scheduler = Rufus::Scheduler.new
  job_id = scheduler.every '1s' do
    amis.run
    if File.exist?("C:/temp/end")
      scheduler.unschedule(job_id)
    end
  end
  scheduler.join
  File.unlink("C:/temp/end")
rescue
  File.unlink("C:/temp/end")
  print "finish by inputting some character(s): "
  gets
end